local ok, notify = pcall(require, "notify")
if not ok then
	return
end

notify.setup({
	timeout = 5000,
	render = "minimal",
	stages = "slide",
})
