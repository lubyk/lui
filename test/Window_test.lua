--[[--
# lui.Window test
--]]--

local lut = require 'lut'
local lui = require 'lui'
local should = lut.Test 'lui.Window'
local Window = lui.Window

function should.autoload()
  assertType('table', Window)
end

function should.print()
  local win = Window()
  assertMatch('lui.Window: 0x%d', win:__tostring())
end


function should.respondToDeleted()
  local win = Window()
  assertFalse(win:deleted())
end

should:test()

