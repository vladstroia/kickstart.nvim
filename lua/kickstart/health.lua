--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]

local check_version = function()
  local verstr = string.format('%s.%s.%s', vim21.version().major, vim21.version().minor, vim21.version().patch)
  if not vim21.version.cmp then
    vim21.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vim21.version.cmp(vim21.version(), { 0, 9, 4 }) >= 0 then
    vim21.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim21.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local check_external_reqs = function()
  -- Basic utils: `git`, `make`, `unzip`
  for _, exe in ipairs { 'git', 'make', 'unzip', 'rg' } do
    local is_executable = vim21.fn.executable(exe) == 1
    if is_executable then
      vim21.health.ok(string.format("Found executable: '%s'", exe))
    else
      vim21.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end

  return true
end

return {
  check = function()
    vim21.health.start 'kickstart.nvim'

    vim21.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

  Fix only warnings for plugins and languages you intend to use.
    Mason will give warnings for languages that are not installed.
    You do not need to install, unless you want to use those languages!]]

    local uv = vim21.uv or vim21.loop
    vim21.health.info('System Information: ' .. vim21.inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
  end,
}
