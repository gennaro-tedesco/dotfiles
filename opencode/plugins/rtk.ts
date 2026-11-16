// RTK command rewrite plugin for OpenCode V2.
// Requires rtk >= 0.23.0 to be available in PATH.
import { execFile } from "node:child_process"
import { promisify } from "node:util"
import { Plugin } from "@opencode/plugin"

const execFileAsync = promisify(execFile)

async function rewrite(command: string) {
  try {
    const { stdout } = await execFileAsync("rtk", ["rewrite", command])
    return stdout.trim() || command
  } catch {
    return command
  }
}

export default Plugin.define({
  id: "rtk",
  async setup(ctx) {
    await ctx.tool.hook("execute.before", async (event) => {
      if (event.tool !== "shell") return

      const input = event.input as { command?: unknown }
      if (typeof input.command !== "string" || !input.command) return

      input.command = await rewrite(input.command)
    })
  },
})
