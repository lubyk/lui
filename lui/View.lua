--[[------------------------------------------------------

  # View

  GUI view with an OpenGL 3 context.

  Usage example:
  
    local lub = require 'lub'
    local lui = require 'lui'

    win = lui.View()

  ## Coordinate system

  All coordinates use bottom-left as zero, Y axis pointing up:

    #txt ascii
    
    ^ Y
    |
    |
    +------> X

  This means that you need to specify *bottom-left* corner
  position for window or view position.


--]]------------------------------------------------------
local lub  = require 'lub'
local lui  = require 'lui'
local core = require 'lui.core'

local lib   = core.View
local o_new = lib.new
local Default = core.View.Default
local o_setParent = lib.setParent

-- # Constructor

-- This constructor does some Lua initialization.
local function new(parent, style)
  local self
  if type(parent) == 'table' then
    self = o_new(style or Default)
    self:setParent(parent)
  else
    self = o_new(parent or Default)
  end

  -- Lua initialization
  self.views = {}

  return self
end

-- nodoc
function lib.new(...)
  return lui.bootstrap(lib, new, ...)
end

-- Create a new view or window. The view is not directly shown. Call #show once
-- the view is ready.
--
-- View style values can be combined and are:
-- + Borderless         : No border and no title bar.
-- + Titled             : Title bar.
-- + Closable           : Display close button.
-- + Miniaturizable     : Display miniaturize button.
-- + Resizable          : Display resize button.
-- + TexturedBackground : Alternate window style (metalized).
-- + Default            : Display title bar and all buttons.
-- 
-- Example for a borderless window with textured background:
--
--   local win = lui.View(lui.View.Borderless + lui.View.TexturedBackground)
-- function lib.new(style)
--
-- Create a view with a parent view.
-- function lib.new(parent, style)

-- Change or set view parent. Setting the parent to nil changes the view to a
-- window.
-- function lib:setParent(view)
-- end
function lib:setParent(parent)
  -- Garbage protection
  if self.parent then
    -- Release child
    self.parent.views[self] = nil
  end

  self.parent = parent

  if parent then
    -- Retain child
    parent.views[self] = self

    o_setParent(self, parent)
  else
    -- This is to pass default value which is NULL because 'nil' is not
    -- treated as valid (View*)NULL.
    o_setParent(self)
  end
end

function lib:addChild(child)
  child:setParent(self)
end

-- Show view. This triggers #moved and #resized callbacks.
-- function lib:show()

-- Hide view.
-- function lib:hide()

-- # Move/resize

-- Get main screen size. Returns two numbers (w, h).
-- function lib.screenSize()

-- Move view to a new pixel position by specifiying *bottom-left* corner
-- location. Movement animation can be turned off with #animateFrame.
function lib:move(x, y)
  local _, _, w, h = self:frame()
  self:setFrame(x, y, w, h)
end

-- Resize view to a new pixel size. Resize animation can be turned off
-- with #animateFrame.
function lib:resize(w, h)
  local x, y, _, _ = self:frame()
  self:setFrame(x, y, w, h)
end

-- Retrieve visible frame (without title bar) as four values:
--   local x, y, w, h = win:frame()
-- function lib:frame()

-- Set the view's visible frame (without title bar).
-- function lib:setFrame(x, y, w, h)

-- Get title bar height.
-- function lib.titleBarHeight()

-- Turn view resize/move animation on or off.
-- function lib:animateFrame(should_animate)

-- # Callbacks

-- Called whenever the view has been or is being moved.
-- The new position is passed as arguments.
-- function lib:moved(x, y)

-- Called when the view has been or is being resized.
-- The new size is passed as arguments.
-- function lib:resized(w, h)

-- Receive mouse click
-- function lib:click()

return lib

