local M = {}
Opts = {}

-- splitting strings
local function split(inputstr, sep)
	sep = sep or '%s'
	local t = {}
	for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
		table.insert(t, str)
	end
	return t
end

-- parse ssh/http url
local function getWebUrl()
	local path = vim.fn.getcwd(0, 0)
	local url
	local gitcmd = string.format('cd "%s" && git ls-remote --get-url', path)
	local gitUri = vim.fn.system(gitcmd)
  -- if @ in url, it's ssh
	if string.find(gitUri, '@') then
		local urlArr = split(gitUri, '@')
		url = urlArr[2]:gsub(':(%d+)/', '/')
		url = url:gsub(':', '/')
	else
		url = gitUri
	end
	return url
end

-- check cwd if it is a git repo
local function isRepo()
	local check = vim.system({ 'bash', '-c', 'git rev-parse --show-toplevel' }, { text = true }):wait()
	if check.code == 0 then
		return true
	else
		return false
	end
end

-- open url handling
local function openUrl(url)
  local cmd
  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    cmd = "start"
  elseif vim.fn.has("mac") == 1 then
    cmd = "open"
  else
    cmd = "xdg-open"
  end
	print('opening https://' .. url)
  vim.fn.system(cmd .. " https://" .. url)
end

function M.setup()
  -- not using any for now
	Opts = {}
	-- Opts = opts or {}
end

function M.open()
	local giturl
	if isRepo() then
		giturl = getWebUrl()
	end
	if not isRepo() then
		print('not a git repo.')
		return
	end
  openUrl(giturl)
end

vim.api.nvim_command('command! GitOpen lua require("gitopen").open()')

return M
