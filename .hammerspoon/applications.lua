local eventtap = require 'hs.eventtap'
local window = require 'hs.window'
local screen = require 'hs.screen'
local mouse = require 'hs.mouse'
local timer = require 'hs.timer'
local windows = require 'windows'
local alert = require "hs.alert"

local mod = {}

alert.defaultStyle = {
    fillColor = {
      alpha = 0.75,
      white = 0
    },
    radius = 10,
    strokeColor = {
      alpha = 0,
      white = 0
    },
    strokeWidth = 5,
    textColor = {
      alpha = 1,
      white = 1
    },
    textFont = "Menlo",
    textSize = 18
}

mod.name = {
  chrome = 'Google Chrome',
  inbox = 'Inbox - ', -- extra characters to be more specific
  slack  = 'Slack'
}

local function wait()
  timer.usleep(10000)
end

local previousTab = nil

local function switchTab()
  local tab = '1'
  if previousTab == '1' then
    tab = '2'
  end
  previousTab = tab
  eventtap.keyStroke({'cmd'}, tab)
  alert('Tab ' .. tab, 0.4)
end

local function clickNotification(offset)
  local currentScreen = mouse.getCurrentScreen()
  local currentPos = mouse.getRelativePosition()
  local targetScreen = screen.primaryScreen()
  local targetPos = { x = targetScreen:frame().w - offset, y = 45 }

  mouse.setRelativePosition(targetPos, targetScreen)
  eventtap.leftClick(targetPos)
  mouse.setRelativePosition(currentPos, currentScreen)
end

function mod.openNotification()
  clickNotification(160)
end

function mod.openNotificationAction()
  clickNotification(40)
end

function mod.slack()
  windows.launchOrCycleFocus(mod.name.slack)()
  wait()
  eventtap.keyStroke({'cmd'}, '1')
  wait()
  eventtap.keyStroke({'cmd'}, 't')
end

function mod.slackUnread()
  mod.slack()
  wait()
  eventtap.keyStrokes('allunread')
  wait()
  eventtap.keyStroke({}, 'return')
end

function mod.chromeOmni()
  windows.launchOrCycleFocus(mod.name.chrome)()
  wait()
  eventtap.keyStroke({'shift'}, 't')
end

function mod.inbox()
  local current = window.focusedWindow()
  local inbox = window.find(mod.name.inbox)

  local isChrome = current:application():title() == mod.name

  if inbox then
    inbox:unminimize()
    inbox:focus()
  elseif isChrome then
    switchTab()
    if not window.find(name.inbox) then
      windows.launchOrCycleFocus(mod.name.chrome)()
      switchTab()
    end
  else
    windows.launchOrCycleFocus(mod.name.chrome)()
    switchTab()
  end
end

function mod.inboxCycle()
  local current = window.focusedWindow()
  local inbox = window.find(mod.name.inbox)

  local isChrome = current:application():title() == mod.name

  if current == inbox then
    switchTab()
  elseif inbox then
    inbox:unminimize()
    inbox:focus()
  elseif isChrome then
    switchTab()
    if not window.find(name.inbox) then
      windows.launchOrCycleFocus(mod.name.chrome)()
      switchTab()
    end
  else
    windows.launchOrCycleFocus(mod.name.chrome)()
    switchTab()
  end
end

function mod.google()
  mod.inbox()
  wait()
  eventtap.keyStroke({'cmd'}, 't')
end

return mod