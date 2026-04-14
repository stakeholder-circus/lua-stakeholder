local script_dir = arg[0]:match("(.*/)") or "./"
package.path = table.concat({
	script_dir .. "../lua/?.lua",
	script_dir .. "../lua/?/init.lua",
	package.path,
}, ";")

local runtime = require("stakeholder.runtime")
local result = runtime.run(arg)

if result.stdout ~= "" then
	io.write(result.stdout)
	if not result.stdout:match("\n$") then
		io.write("\n")
	end
end

if result.stderr ~= "" then
	io.stderr:write(result.stderr)
	if not result.stderr:match("\n$") then
		io.stderr:write("\n")
	end
end

os.exit(result.exit_code, true)
