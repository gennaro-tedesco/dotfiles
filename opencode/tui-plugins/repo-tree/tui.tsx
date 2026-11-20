import { execFile } from "node:child_process"
import { watch } from "node:fs"
import { readdir, readFile, stat } from "node:fs/promises"
import { join, relative } from "node:path"
import { promisify } from "node:util"
import { createEffect, createResource, createSignal, For, Match, onCleanup, onMount, Show, Switch } from "solid-js"
import { createStore } from "solid-js/store"
import { Plugin, usePlugin } from "@opencode/plugin/tui"
import { generateSyntax, type ResolvedTheme } from "@opencode/theme/tui"
import { pathToFiletype, type RGBA, type SyntaxStyle } from "@opentui/core"

type Entry = { name: string; path: string; dir: boolean }
type Row = { entry: Entry; prefix: string }

const PANEL = "repo-tree.file"
const MAX_BYTES = 512 * 1024
const MAX_RESULTS = 50
const LIST_TTL_MS = 5000
const run = promisify(execFile)

type SearchResult = { files: string[]; note?: string }

let listing: { at: number; files: string[] } | undefined

async function listFiles(root: string): Promise<string[]> {
  if (listing && Date.now() - listing.at < LIST_TTL_MS) return listing.files
  const { stdout } = await run("fd", ["--type", "f"], { cwd: root, maxBuffer: 64 * 1024 * 1024 })
  listing = { at: Date.now(), files: stdout.split("\n").filter(Boolean) }
  return listing.files
}

async function find(root: string, query: string): Promise<SearchResult> {
  try {
    const terms = query.toLowerCase().split(/\s+/).filter(Boolean)
    const nameHits = (file: string) => {
      const name = file.slice(file.lastIndexOf("/") + 1).toLowerCase()
      return terms.filter((term) => name.includes(term)).length
    }
    const files = (await listFiles(root))
      .filter((file) => terms.every((term) => file.toLowerCase().includes(term)))
      .sort((a, b) => nameHits(b) - nameHits(a) || a.length - b.length)
      .slice(0, MAX_RESULTS)
    return { files }
  } catch (error) {
    const missing = (error as NodeJS.ErrnoException).code === "ENOENT"
    return { files: [], note: missing ? "fd not found in PATH" : "Search failed" }
  }
}

const [selected, setSelected] = createSignal<string | undefined>()

async function load(path: string): Promise<{ text?: string; note?: string }> {
  const info = await stat(path).catch(() => undefined)
  if (!info) return { note: "File not found" }
  if (info.size > MAX_BYTES) return { note: `File too large (${Math.round(info.size / 1024)} KB, limit ${MAX_BYTES / 1024} KB)` }
  const buffer = await readFile(path)
  if (buffer.subarray(0, 8000).includes(0)) return { note: "Binary file" }
  return { text: buffer.toString("utf8") }
}

type SyntaxKey = keyof ResolvedTheme["syntax"]

type FileIcon = { char: string; token: SyntaxKey }

const FILE_ICONS: Record<string, FileIcon> = {
  py: { char: "", token: "string" },
  ts: { char: "", token: "type" },
  tsx: { char: "", token: "type" },
  js: { char: "", token: "number" },
  json: { char: "", token: "number" },
  md: { char: "", token: "keyword" },
  toml: { char: "", token: "variable" },
  yml: { char: "", token: "variable" },
  yaml: { char: "", token: "variable" },
  sh: { char: "", token: "operator" },
  rs: { char: "", token: "number" },
  go: { char: "", token: "type" },
  java: { char: "", token: "string" },
  rb: { char: "", token: "keyword" },
  c: { char: "", token: "function" },
  h: { char: "", token: "function" },
  cpp: { char: "", token: "function" },
  swift: { char: "", token: "keyword" },
  kt: { char: "", token: "keyword" },
  php: { char: "", token: "variable" },
  html: { char: "", token: "operator" },
  css: { char: "", token: "type" },
  scss: { char: "", token: "type" },
  lock: { char: "", token: "comment" },
  env: { char: "", token: "string" },
  ini: { char: "", token: "variable" },
  xml: { char: "", token: "operator" },
  csv: { char: "", token: "string" },
  sql: { char: "", token: "keyword" },
  dockerfile: { char: "", token: "type" },
  txt: { char: "", token: "comment" },
  rst: { char: "", token: "comment" },
  pdf: { char: "", token: "number" },
  png: { char: "", token: "number" },
  jpg: { char: "", token: "number" },
  gif: { char: "", token: "number" },
  svg: { char: "", token: "number" },
}

const NAME_ICONS: Record<string, FileIcon> = {
  ".gitignore": { char: "", token: "operator" },
  ".gitattributes": { char: "", token: "operator" },
  ".env": { char: "", token: "string" },
  makefile: { char: "", token: "function" },
  dockerfile: { char: "", token: "type" },
  license: { char: "", token: "comment" },
  "package.json": { char: "", token: "string" },
}

function lookup(name: string): FileIcon | undefined {
  const lower = name.toLowerCase()
  if (lower.startsWith(".env.")) return NAME_ICONS[".env"]
  return NAME_ICONS[lower] ?? FILE_ICONS[lower.split(".").pop() ?? ""]
}

function icon(theme: ResolvedTheme, entry: Entry, open: boolean): { char: string; color: RGBA } {
  if (entry.dir) return { char: open ? "" : "", color: theme.syntax.function }
  const match = lookup(entry.name)
  return match ? { char: match.char, color: theme.syntax[match.token] } : { char: "", color: theme.text.muted }
}

async function list(dir: string): Promise<Entry[]> {
  const entries = await readdir(dir, { withFileTypes: true }).catch(() => [])
  return entries
    .filter((e) => e.name !== ".git")
    .map((e) => ({ name: e.name, path: join(dir, e.name), dir: e.isDirectory() }))
    .sort((a, b) => Number(b.dir) - Number(a.dir) || a.name.localeCompare(b.name, undefined, { sensitivity: "base" }))
}

function RepoTree(props: { root: string; revision: number }) {
  const context = usePlugin()
  const [collapsed, setCollapsed] = createSignal(false)
  const [state, setState] = createStore<{ children: Record<string, Entry[]>; open: Record<string, boolean> }>({
    children: {},
    open: {},
  })

  const [query, setQuery] = createSignal("")
  const [searching, setSearching] = createSignal(false)
  const [results, setResults] = createSignal<SearchResult | undefined>()
  let timer: ReturnType<typeof setTimeout> | undefined
  let request = 0

  const refresh = async () => {
    listing = undefined
    const paths = [props.root, ...Object.keys(state.open).filter((path) => state.open[path])]
    const entries = await Promise.all(paths.map((path) => list(path)))
    paths.forEach((path, index) => setState("children", path, entries[index]))
  }

  createEffect(() => {
    props.revision
    void refresh()
  })
  onCleanup(() => clearTimeout(timer))

  const openFile = (path: string) => {
    setSelected(path)
    context.ui.panel.open(PANEL, { presentation: "fullscreen" })
  }

  const search = (value: string) => {
    setQuery(value)
    clearTimeout(timer)
    request++
    setResults(undefined)
    const text = value.trim()
    if (!text) return
    timer = setTimeout(async () => {
      const id = request
      const found = await find(props.root, text)
      if (id === request) setResults(found)
    }, 150)
  }

  context.keymap.layer(() => ({
    commands: [
      {
        bind: "escape",
        enabled: () => searching(),
        run: () => {
          setSearching(false)
          search("")
        },
      },
    ],
  }))

  const toggle = async (entry: Entry) => {
    if (!entry.dir) {
      openFile(entry.path)
      return
    }
    if (!state.open[entry.path]) setState("children", entry.path, await list(entry.path))
    setState("open", entry.path, !state.open[entry.path])
  }

  const rows = (path: string, prefix: string): Row[] => {
    const children = state.children[path] ?? []
    return children.flatMap((entry, i) => {
      const last = i === children.length - 1
      const row = { entry, prefix: prefix + (last ? "└── " : "├── ") }
      return state.open[entry.path] ? [row, ...rows(entry.path, prefix + (last ? "    " : "│   "))] : [row]
    })
  }

  return (
    <box flexDirection="column" marginTop={1}>
      <box onMouseDown={() => setCollapsed(!collapsed())}>
        <text fg={context.theme.text.base}>{collapsed() ? "▶" : "▼"} Files</text>
      </box>
      <Show when={!collapsed()}>
        <box onMouseDown={() => setSearching(true)}>
          <input
            placeholder="Search files…"
            value={query()}
            focused={searching()}
            onInput={search}
            textColor={context.theme.text.base}
            placeholderColor={context.theme.text.faint}
          />
        </box>
        <Show
          when={query().trim()}
          fallback={
            <For each={rows(props.root, "")}>
              {(row) => {
                const glyph = () => icon(context.theme, row.entry, !!state.open[row.entry.path])
                return (
                  <box flexDirection="row" onMouseDown={() => toggle(row.entry)}>
                    <text>
                      <span style={{ fg: context.theme.text.faint }}>{row.prefix}</span>
                      <span style={{ fg: glyph().color }}>{glyph().char} </span>
                      <span style={{ fg: row.entry.dir ? context.theme.syntax.function : context.theme.text.base }}>
                        {row.entry.name}
                      </span>
                    </text>
                  </box>
                )
              }}
            </For>
          }
        >
          <Show when={results()} fallback={<text fg={context.theme.text.muted}>Searching…</text>}>
            {(found) => (
              <Show
                when={found().files.length}
                fallback={<text fg={context.theme.text.muted}>{found().note ?? "No matches"}</text>}
              >
                <For each={found().files}>
                  {(file) => {
                    const entry: Entry = { name: file.split("/").pop() ?? file, path: join(props.root, file), dir: false }
                    const glyph = icon(context.theme, entry, false)
                    return (
                      <box flexDirection="row" onMouseDown={() => openFile(entry.path)}>
                        <text>
                          <span style={{ fg: glyph.color }}>{glyph.char} </span>
                          <span style={{ fg: context.theme.text.base }}>{file}</span>
                        </text>
                      </box>
                    )
                  }}
                </For>
              </Show>
            )}
          </Show>
        </Show>
      </Show>
    </box>
  )
}

function Sidebar(props: { root: string }) {
  const context = usePlugin()
  const [revision, setRevision] = createSignal(0)
  let timer: ReturnType<typeof setTimeout> | undefined

  onMount(() => {
    const watcher = watch(props.root, { recursive: true }, () => {
      clearTimeout(timer)
      timer = setTimeout(() => {
        setRevision((value) => value + 1)
        const location = context.location ?? context.data.location.default()
        context.data.location.vcs.invalidate(location)
        void context.data.location.vcs.sync(location)
      }, 100)
    })
    onCleanup(() => {
      clearTimeout(timer)
      watcher.close()
    })
  })

  return <RepoTree root={props.root} revision={revision()} />
}

function FileViewer(props: {
  root: string
  style: SyntaxStyle
  panel: { focused: boolean; close: () => void; toggleFullscreen: () => void }
}) {
  const context = usePlugin()
  const [file] = createResource(selected, load)
  const ext = () => (selected() ?? "").split(".").pop()?.toLowerCase() ?? ""

  context.keymap.layer(() => ({
    commands: [{ bind: "escape", run: () => props.panel.close() }],
  }))

  return (
    <box flexDirection="column" flexGrow={1}>
      <box flexDirection="row" justifyContent="space-between" paddingLeft={1} paddingRight={1}>
        <text fg={context.theme.text.base}>{relative(props.root, selected() ?? "")}</text>
        <box flexDirection="row" gap={2}>
          <box onMouseDown={() => props.panel.toggleFullscreen()}>
            <text fg={context.theme.text.muted}>⛶</text>
          </box>
          <box onMouseDown={() => props.panel.close()}>
            <text fg={context.theme.text.muted}>✕</text>
          </box>
        </box>
      </box>
      <scrollbox flexGrow={1} scrollX scrollY focused={props.panel.focused}>
        <Show when={file()} fallback={<text fg={context.theme.text.muted}>Loading…</text>}>
          {(data) => (
            <Switch>
              <Match when={data().note}>
                <text fg={context.theme.text.muted}>{data().note}</text>
              </Match>
              <Match when={ext() === "md"}>
                <markdown content={data().text ?? ""} syntaxStyle={props.style} />
              </Match>
              <Match when={true}>
                <code content={data().text ?? ""} filetype={pathToFiletype(selected() ?? "")} syntaxStyle={props.style} wrapMode="none" />
              </Match>
            </Switch>
          )}
        </Show>
      </scrollbox>
    </box>
  )
}

export default Plugin.define({
  id: "repo-tree",
  setup(context) {
    const root = context.location?.directory ?? context.data.location.default().directory
    const style = generateSyntax(context.theme, context.renderer.nativeScene)
    const stopSidebar = context.ui.slot({
      append: "sidebar.content",
      render: () => <Sidebar root={root} />,
    })
    const stopPanel = context.ui.slot({
      append: "session.panel",
      render: (panel) => (
        <Show when={panel.name === PANEL && selected()}>
          <FileViewer root={root} style={style} panel={panel} />
        </Show>
      ),
    })
    return () => {
      stopSidebar()
      stopPanel()
      return context.renderer.idle().then(() => style.destroy())
    }
  },
})
