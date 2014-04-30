--[[--
# lui.Application test
--]]--

local lut = require 'lut'
local lui = require 'lui'
local should = lut.Test 'lui.Application'
local Application = lui.Application

function should.makeLib()
  assertType('table', lui)
end

function should.autoload()
  assertType('table', Application)
end

function should.print()
  local app = Application()
  assertMatch('lui.Application: 0x%d', app:__tostring())
end

function should.alwaysReturnSameApp()
  local app  = Application()
  local app2 = Application()
  assertEqual(app, app2)
end

function should.respondToDeleted()
  local app = Application()
  assertFalse(app:deleted())
end

function should.respondToBringToFront()
  local app = Application()
  assertPass(function()
    app:bringToFront()
  end)
end

should.ignore.__gc = true
should.ignore.exec = true

should:test()

