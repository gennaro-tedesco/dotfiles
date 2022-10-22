local ok, _ = pcall(require, "inc_rename")
if not ok then
	return
end
require("inc_rename").setup()
