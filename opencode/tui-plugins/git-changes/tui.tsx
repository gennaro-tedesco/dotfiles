import { execFile } from "node:child_process"
import { watch } from "node:fs"
import { promisify } from "node:util"
import { createResource, createSignal, For, onCleanup, onMount, Show } from "solid-js"
import { Plugin, usePlugin } from "@opencode/plugin/tui"
import { generateSyntax } from "@opencode/theme/tui"
import type { SyntaxStyle } from "@opentui/core"

type Change = { path: string; status: string }

const PANEL = "git-changes.diff"
const run = promisify(execFile)

let selected: Change | undefined

async function changes(root: string): Promise<Change[] | undefined> {
  try {
    await run("git", ["rev-parse", "--is-inside-work-tree"], { cwd: root })
    const { stdout } = await run("git", ["status", "--porcelain=v1", "-z"], { cwd: root })
    const entries = stdout.split("\0")
    const result: Change[] = []
    for (let index = 0; index < entries.length - 1; index++) {
      const entry = entries[index]
      const status = entry.slice(0, 2)
      result.push({ status, path: entry.slice(3) })
      if (status.includes("R") || status.includes("C")) index++
    }
    return result
  } catch {
    return undefined
  }
}

async function diff(root: string, change: Change | undefined): Promise<string> {
  if (!change) return ""
  if (change.status === "??") {
    const result = await run("git", ["diff", "--no-color", "--no-index", "--", "/dev/null", change.path], { cwd: root }).catch(
      (error: { stdout?: string }) => ({ stdout: error.stdout ?? "" }),
    )
    return result.stdout
  }
  const { stdout } = await run("git", ["diff", "--no-color", "HEAD", "--", change.path], { cwd: root })
  return stdout || "No diff available"
}

function GitChanges(props: { root: string }) {
  const context = usePlugin()
  const [items, setItems] = createSignal<Change[] | undefined>()
  const [collapsed, setCollapsed] = createSignal(false)
  let timer: ReturnType<typeof setTimeout> | undefined

  const refresh = async () => setItems(await changes(props.root))

  onMount(() => {
    void refresh()
    const watcher = watch(props.root, { recursive: true }, () => {
      clearTimeout(timer)
      timer = setTimeout(() => void refresh(), 100)
    })
    onCleanup(() => {
      clearTimeout(timer)
      watcher.close()
    })
  })

  const openDiff = (change: Change) => {
    selected = change
    context.ui.panel.open(PANEL, { presentation: "fullscreen" })
  }

  return (
    <Show when={items()}>
      <box flexDirection="column" marginTop={1}>
        <box onMouseDown={() => setCollapsed(!collapsed())}>
          <text fg={context.theme.text.base}>{collapsed() ? "▶" : "▼"} Changes</text>
        </box>
        <Show when={!collapsed()}>
          <Show when={items()!.length} fallback={<text fg={context.theme.text.muted}>No changes</text>}>
            <For each={items()}>
              {(change) => (
                <box flexDirection="row" onMouseDown={() => openDiff(change)}>
                  <text>
                    <span style={{ fg: context.theme.syntax.keyword }}>{change.status} </span>
                    <span style={{ fg: context.theme.text.base }}>{change.path}</span>
                  </text>
                </box>
              )}
            </For>
          </Show>
        </Show>
      </box>
    </Show>
  )
}

function DiffViewer(props: {
  root: string
  style: SyntaxStyle
  panel: { focused: boolean; close: () => void; toggleFullscreen: () => void }
}) {
  const context = usePlugin()
  const [content] = createResource(() => selected, (change) => diff(props.root, change))

  context.keymap.layer(() => ({
    commands: [{ bind: "escape", run: () => props.panel.close() }],
  }))

  return (
    <box flexDirection="column" flexGrow={1}>
      <box flexDirection="row" justifyContent="space-between" paddingLeft={1} paddingRight={1}>
        <text fg={context.theme.text.base}>{selected?.path}</text>
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
        <Show when={content()} fallback={<text fg={context.theme.text.muted}>Loading…</text>}>
          {(value) => <code content={value()} filetype="diff" syntaxStyle={props.style} wrapMode="none" />}
        </Show>
      </scrollbox>
    </box>
  )
}

export default Plugin.define({
  id: "git-changes",
  setup(context) {
    const root = context.location?.directory ?? context.data.location.default().directory
    const style = generateSyntax(context.theme, context.renderer.nativeScene)
    const stopSidebar = context.ui.slot({
      append: "sidebar.content",
      render: () => <GitChanges root={root} />,
    })
    const stopPanel = context.ui.slot({
      append: "session.panel",
      render: (panel) => (
        <Show when={panel.name === PANEL && selected}>
          <DiffViewer root={root} style={style} panel={panel} />
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
