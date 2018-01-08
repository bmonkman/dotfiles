local fnutils = require 'hs.fnutils'
local hotkey = require 'hs.hotkey'
local grid = require 'hs.grid'
local hints = require 'hs.hints'
local caffeinate = require 'hs.caffeinate'
local windows = require 'windows'
local layout = require 'hs.layout'
local audio = require 'audio'
local applications = require 'applications'
local logger = hs.logger.new('bindings', 'debug')

local hyper = { 'cmd', 'alt', 'ctrl', 'shift' }
local hyperShift = { 'cmd', 'alt', 'ctrl', 'shift' }

local mod = {}


--------------------------------------
-- binds functions to hyper key end --
--------------------------------------

hotkey.bind({ 'option' }, 'tab', hints.windowHints)

local hyperBindings = {
    -- Code
  { key = '-', name = 'Sequel Pro' },
  { key = '1', name = 'iTerm' },
  { key = '2', name = 'IntelliJ IDEA.app' },
  { key = '3', name = 'Visual Studio Code' },
  -- Productivity / other
  { key = 'q', name = applications.name.chrome },
  { key = 'w', name = applications.name.slack },
  { key = 'e', name = '1Password' },
  { key = 'r', name = 'Spotify' },

  { key = 'a', fn = applications.inbox },
  { key = 's', fn = applications.slackUnread },
  { key = 'd', name = 'Bear' },
  { key = 'f', name = 'Finder' },
  { key = 'g', fn = applications.google },
  

  { key = 'x', fn = applications.openNotification },
  { key = 'o', fn = applications.openNotification },
  { key = 'p', fn = applications.openNotificationAction },
  
  { key = '\\', fn = audio.current },
  
--   { key = ';', name = 'Dash' },
--   { key = 'b', fn = applications.openNotificationAction, shift = true },
--   { key = 'e', name = 'Charles' },
--   { key = 'f', name = 'Preview', shift = true },
--   { key = 'g', fn = windows.altGrid, shift = true },
--   { key = 'i', name = 'iTerm2' },
  { key = 'j', pos = { { 0.0, 0.0, 0.5, 1.0}, { 0.0, 0.0, 0.7, 1.0} } },
--   { key = 'j', pos = { { 0.00, 0.00, 0.30, 1.00 }, { 0.00, 0.00, 0.70, 1.00 } }, shift = true },
  { key = 'k', pos = { { 0.5, 0.0, 0.5, 1.0}, { 0.3, 0.0, 0.7, 1.0} } },
--   { key = 'k', pos = { { 0.70, 0.00, ˆ0.30, 1.00 }, { 0.30, 0.00, 0.70, 1.00 } }, shift = true },
--   { key = 'l', fn = applications.chromeOmni, shift = true },
  { key = 'm', pos = { 0.00, 0.00, 1.00, 1.00 } },
--   { key = 'm', pos = { 0.00, 0.00, 1.00, 1.00 }, shift = true, targetScreen = 'current' },
  { key = 'n', pos = { { 0.30, 0.00, 0.40, 1.00 }, { 0.20, 0.00, 0.60, 1.00 } }, reversable = true },
--   { key = 'n', pos = { { 0.30, 0.05, 0.40, 0.60 }, { 0.20, 0.05, 0.60, 0.80 }, { 0.30, 0.05, 0.40, 0.30 } }, shift = true },
--   { key = 'p', name = 'Sublime Text' },
--   { key = 's', name = 'Visual Studio Code' },
--   { key = 'q', fn = windows.snapAll },
--   { key = 'q', fn = applications.inbox },
  { key = 'z', fn = caffeinate.startScreensaver },

  { key = 'up', fn = grid.resizeWindowShorter },
  { key = 'down', fn = grid.resizeWindowTaller },
  { key = 'left', fn = grid.resizeWindowThinner },
  { key = 'right', fn = grid.resizeWindowWider },
  { key = 'pageup', fn = windows.previousScreen },
  { key = 'pagedown', fn = windows.nextScreen },
  { key = 'pad8', fn = grid.pushWindowUp, shift = true },
  { key = 'pad2', fn = grid.pushWindowDown, shift = true },
  { key = 'pad4', fn = grid.pushWindowLeft, shift = true },
  { key = 'pad6', fn = grid.pushWindowRight, shift = true },
}

-------------------------
-- create general mode --
-------------------------

local generalBindings = {
}

------------------------
-- create layout mode --
------------------------

local commonLayout = {
  { name = "Inbox", screenFn = windows.alternateScreen, pos = { 0.00, 0.00, 1.00, 0.70 } },
  { name = "Slack", screenFn = windows.alternateScreen, pos = { 0.00, 0.30, 1.00, 0.70 } },
}

local modeLayouts = {
--                      x     y     w     h
  { key = '1', pos = { 0.00, 0.00, 0.50, 0.50 } },
  { key = '2', pos = { 0.50, 0.00, 0.50, 0.50 } },
  { key = '3', pos = { 0.00, 0.00, 1.00, 0.50 } },
  { key = 'q', pos = { 0.00, 0.50, 0.50, 0.50 } },
  { key = 'a', pos = { 0.00, 0.00, 0.50, 1.00 } },
  { key = 's', pos = { 0.50, 0.00, 0.50, 1.00 } },
  { key = 'w', pos = { 0.50, 0.50, 0.50, 0.50 } },
  { key = 'e', pos = { 0.00, 0.50, 1.00, 0.50 } },
  { key = 'h', pos = { 0.00, 0.00, 0.70, 1.00 } },
  { key = 'd', pos = { 0.10, 0.10, 0.80, 0.80 } },
  { key = 'f', pos = { 0.20, 0.20, 0.60, 0.60 } },
  { key = ';', pos = { 0.30, 0.00, 0.70, 1.00 } },
  { key = 'j', pos = { 0.00, 0.00, 0.30, 1.00 } },
  { key = 'k', pos = { 0.30, 0.00, 0.40, 1.00 } },
  { key = 'l', pos = { 0.70, 0.00, 0.30, 1.00 } },
  { key = '6', pos = { 0.00, 0.00, 0.70, 0.50 } },
  { key = '7', pos = { 0.00, 0.00, 0.30, 0.50 } },
  { key = '8', pos = { 0.30, 0.00, 0.40, 0.50 } },
  { key = '9', pos = { 0.70, 0.00, 0.30, 0.50 } },
  { key = '0', pos = { 0.30, 0.00, 0.70, 0.50 } },
  { key = 'y', pos = { 0.00, 0.50, 0.70, 0.50 } },
  { key = 'u', pos = { 0.00, 0.50, 0.30, 0.50 } },
  { key = 'i', pos = { 0.30, 0.50, 0.40, 0.50 } },
  { key = 'o', pos = { 0.70, 0.50, 0.30, 0.50 } },
  { key = 'p', pos = { 0.30, 0.50, 0.70, 0.50 } },
  { key = 'space', fn = hints.windowHints },
  { key = '=', fn = grid.resizeWindowWider },
  { key = '-', fn = grid.resizeWindowThinner },
  { key = 'm', fn = windows.cycleScreenBack },
  { key = 'n', fn = windows.cycleScreen },
  { key = 'z', layout = {
      { 'iTerm2', layout.right50 },
      { 'Google Chrome', layout.right50 },
      { 'IntelliJ IDEA', layout.right50 },
      { 'Sublime Text', layout.right50 },
    }},
  { key = 'x', layout = {
      { 'IntelliJ IDEA', layout.right70 },
      { 'Google Chrome', layout.right30 },
      { 'iTerm2', layout.right30 },
    }},
  { key = 'c', layout = {
      { 'Google Chrome', layout.right70 },
      { 'IntelliJ IDEA', layout.right70 },
      { 'iTerm2', layout.right70 },
    }},
}

local function buildBindFunction(binding)
  if binding.pos and binding.targetScreen then
    return windows.setPosition(binding.pos, binding.targetScreen, binding.reversable)
  elseif binding.pos then
    return windows.setPosition(binding.pos, 'primary', binding.reversable)
  elseif binding.layout then
    return windows.applyLayout(commonLayout, binding.layout)
  elseif binding.name then
    return windows.launchOrCycleFocus(binding.name)
  elseif binding.fn then
    return binding.fn
  end
end

local function buildLayoutBinding(binding)
  return { key = binding.key, fn = buildBindFunction(binding) }
end

local function bindToHyper(binding)
  local modifier = hyper

  if binding.shift then
    modifier = hyperShift
  end

  hotkey.bind(modifier, binding.key, buildBindFunction(binding))
end

function mod.init()
  fnutils.each(hyperBindings, bindToHyper)

  hotkey.bind({'cmd'}, 'h', applications.slack)
  hotkey.bind({'cmd'}, 'm', windows.cycleScreen)
  hotkey.bind({'cmd', 'option'}, 'm', windows.cycleScreen)
end

return mod
