
local alert = require "hs.alert"

local reload = require "utils/reload"
local bindings = require "bindings"

reload.init()
bindings.init()

alert.show("Config loaded")