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


local app_terminal = 'Ghostty' -- 'iTerm2'
local app_editor = 'Visual Studio Code' -- 'IntelliJ IDEA'
local app_browser = 'Google Chrome' -- 'Firefox'
local app_chat = applications.name.slack
local app_music = 'Spotify' -- 'Tidal'
local app_password = '1Password'

--------------------------------------
-- binds functions to hyper key end --
--------------------------------------

--hotkey.bind({ 'option' }, 'tab', hints.windowHints)
hotkey.bind({ }, 'f20', windows.previousWindow)

local hyperBindings = {
    -- Code
  { key = '-', name = 'Sequel Pro' },
  { key = '1', name = app_terminal },
  { key = '2', name = app_editor },
  { key = 'q', name = app_browser },
  { key = 'w', name = app_chat },
  { key = 'e', name = app_password },
  { key = 'r', name = app_music },

  { key = 'a', fn = applications.chromeOmni },
  { key = 's', fn = applications.slack },
  { key = 'd', name = 'Bear' },
  { key = 'f', name = 'Finder' },
  { key = 'g', fn = applications.google },


  { key = 'z', fn = applications.openNotification },
  { key = 'o', fn = applications.openNotification },
  { key = 'x', fn = applications.openNotificationAction },

  { key = '\\', fn = audio.current },
  { key = '\'', fn = windows.previousWindow },

--   { key = ';', name = 'Dash' },
--   { key = 'b', fn = applications.openNotificationAction, shift = true },
--   { key = 'e', name = 'Charles' },
--   { key = 'f', name = 'Preview', shift = true },
--   { key = 'g', fn = windows.altGrid, shift = true },
--   { key = 'i', name = 'iTerm2' },
  { key = 'j', pos = { { 0.0, 0.0, 0.5, 1.0}, { 0.0, 0.0, 0.7, 1.0} } },
  { key = 'h', pos = { { 0.00, 0.00, 0.30, 1.00 }, { 0.00, 0.00, 0.70, 1.00 } } },
  { key = 'k', pos = { { 0.5, 0.0, 0.5, 1.0}, { 0.3, 0.0, 0.7, 1.0} } },
  { key = 'l', pos = { { 0.70, 0.00, 0.30, 1.00 }, { 0.30, 0.00, 0.70, 1.00 } } },
  { key = 'm', pos = { { 0.00, 0.00, 1.00, 1.00 }, { 0.20, 0.20, 0.60, 0.60 } } },
  -- { key = 'h', fn = function() windows.push(0,0,0.3,1) end },
  -- { key = 'j', fn = function() windows.push(0,0,0.3,1) end },
  -- { key = 'k', fn = function() windows.push((1/2*2),0,(1/2),1) end },
  -- { key = 'l', fn = function() windows.push((1/3*2),0,(1/3),1) end },
--  { key = 'm', pos = { 0.00, 0.00, 1.00, 1.00 } },
--   { key = 'm', pos = { 0.00, 0.00, 1.00, 1.00 }, shift = true, targetScreen = 'current' },
  { key = 'n', pos = { { 0.30, 0.00, 0.40, 1.00 }, { 0.20, 0.00, 0.60, 1.00 } }, reversable = true },
--   { key = 'n', pos = { { 0.30, 0.05, 0.40, 0.60 }, { 0.20, 0.05, 0.60, 0.80 }, { 0.30, 0.05, 0.40, 0.30 } }, shift = true },
--   { key = 'p', name = 'Sublime Text' },
--   { key = 's', name = 'Visual Studio Code' },
--   { key = 'q', fn = windows.snapAll },
--   { key = 'q', fn = applications.inbox },
  { key = '`', fn = caffeinate.startScreensaver },

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
  { key = 'pad-', fn = windows.maximize },
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
      { app_terminal, layout.right50 },
      { 'Google Chrome', layout.right50 },
      { 'IntelliJ IDEA', layout.right50 },
      { 'Sublime Text', layout.right50 },
    }},
  { key = 'x', layout = {
      { app_editor, layout.right70 },
      { app_browser, layout.right30 },
      { app_terminal, layout.right30 },
    }},
  { key = 'c', layout = {
      { app_browser, layout.right70 },
      { app_editor, layout.right70 },
      { app_terminal, layout.right70 },
    }},
}

local function buildBindFunction(binding)
  if binding.pos and binding.targetScreen then
    return windows.setPosition(binding.pos, binding.targetScreen, binding.reversable)
  elseif binding.pos then
    return windows.setPosition(binding.pos, 'secondary', binding.reversable)
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

--function keyDown(e)
--  logger.df('KeyDown: %s', e:getKeyCode())
--  if e:getKeyCode() == 110 then -- Bound r ctrl to "application" in karabiner.. *shrug*
--    windows.previousWindow()
--  end
--end

--function otherMouseDown(e)
--  logger.df('otherMouseDown: %s', e:getButtonState(32))
--  if e:getButtonState(31) then -- Bound r ctrl to "button 31" in karabiner.. *shrug*
--    windows.previousWindow()
--  end
--end

--tap = eventtap.new({event.types.otherMouseDown}, otherMouseDown)
--tap:start()

return mod
