--[[------------------------------------------------------

  lui.FileHandle
  --------------


--]]------------------------------------------------------
local lui    = require 'lui'
local lut    = require 'lut'
local lens   = require 'lens'
local should = lut.Test 'lui.FileHandle'

local FileHandle,          sleep,      elapsed =
      lui.FileHandle, lens.sleep, lens.elapsed

function should.createFileHandle()
  local t = FileHandle(5, function()
  end)
  assertEqual('lui.FileHandle', t.type)
end

function should.respondToDeleted()
  local t = FileHandle(5)
  assertFalse(t:deleted())
end

function should.renderToString()
  local t = FileHandle(5)
  assertMatch('lui.FileHandle 5: 0x', tostring(t))
end

function should.enableFileHandle()
  local t = FileHandle(0.5)
  assertPass(function()
    t:setEnabled(false)
  end)
end

should:test()
