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

function should.respondToMove()
  local win = Window()
  win:move(15, 32)
  local x, y = win:frame()
  assertEqual(15, x)
  assertEqual(32, y)
end

function should.respondToResize()
  local win = Window()
  win:resize(150, 320)
  local _, _, w, h = win:frame()
  assertEqual(150, w)
  assertEqual(320, h)
end

function should.setAndReturnFrame()
  local win = Window()
  win:setFrame(100, 20, 200, 300)
  local x, y, w, h = win:frame()
  assertEqual(100, x)
  assertEqual(20, y)
  assertEqual(200, w)
  assertEqual(300, h)
end

should:test()

