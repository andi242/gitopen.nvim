local M = {}
GitopenOpts = {}

-- splitting strings
local function split(inputstr, sep)
	sep = sep or "%s"
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

-- parse ssh/http url, return false on error
local function getWebUrl()
	local path = vim.fn.getcwd(0, 0)
	local url
	local gitcmd = string.format('cd "%s" && git ls-remote --get-url', path)
	local check = vim.system({ "bash", "-c", gitcmd }, { text = true }):wait()
	if check.code == 0 then
		local gitUri = string.format(check.stdout)
		-- if @ in url, it's ssh
		if string.find(gitUri, "@") then
			local urlArr = split(gitUri, "@")
			url = urlArr[2]:gsub(":(%d+)/", "/")
			url = url:gsub(":", "/")
		-- how to strip '.git'? or just ignore?
		-- url = url.gsub('%.git$', '') -- does not work?
		-- url = url:sub(0, -6) -- works, but unsafe
		else
			url = gitUri
		end
		return url
	else
		return false
	end
end

-- check host exec env
local function checkEnv()
	local cmd
	if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
		cmd = "start"
	elseif vim.fn.has("mac") == 1 then
		cmd = "open"
	else
		cmd = "xdg-open"
	end
  return cmd
end

-- open url handling
local function openUrl(url)
	print("opening https://" .. url)
  local cmd = checkEnv()
	vim.fn.system(cmd .. " https://" .. url)
end

function M.setup(opts)
	-- not using any for now
	GitopenOpts = opts or {}
  local cmd = checkEnv()
  local checkcmd = assert(vim.fn.executable(cmd) == 1, "command '" .. cmd .."' is unavailable.")
  if not checkcmd then
    print(checkcmd)
  end
end

function M.open()
	local giturl = getWebUrl()
	if giturl then
		openUrl(giturl)
	else
		print( vim.fn.getcwd(0, 0) .. " is not a git repo.")
		return
	end
end

vim.api.nvim_command('command! GitOpen lua require("gitopen").open()')

return M
