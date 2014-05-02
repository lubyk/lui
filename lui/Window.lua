--[[------------------------------------------------------

  # Window

  GUI window with an OpenGL 3 context.

  Usage example:
  
    local lub = require 'lub'
    local lui = require 'lui'

    win = lui.Window()

  ## Coordinate system

  All coordinates use bottom-left as zero, Y axis pointing up:

    #txt ascii
    
    ^ Y
    |
    |
    +------> X

  This means that you need to specify *bottom-left* corner
  position for window position.


--]]------------------------------------------------------
local lub  = require 'lub'
local lui  = require 'lui'
local core = require 'lui.core'

local lib  = core.Window
local new  = lib.new
local Default = core.Window.Default

-- # Constructor

-- Create a new window. The window is not directly shown. Call #show once the
-- window is ready.
--
-- Window style values can be combined and are:
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
--   local win = lui.Window(lui.Window.Borderless + lui.Window.TexturedBackground)
function lib.new(style)
  return lui.bootstrap(lib, new, style or Default)
end

-- Show window. This triggers #moved and #resized callbacks.
-- function lib:show()

-- Hide window.
-- function lib:hide()

-- # Move/resize

-- Get main screen size. Returns two numbers (w, h).
-- function lib.screenSize()

-- Move window to a new pixel position by specifiying *bottom-left* corner
-- location. Movement animation can be turned off with #animateFrame.
function lib:move(x, y)
  local _, _, w, h = self:frame()
  self:setFrame(x, y, w, h)
end

-- Resize window to a new pixel size. Resize animation can be turned off
-- with #animateFrame.
function lib:resize(w, h)
  local x, y, _, _ = self:frame()
  self:setFrame(x, y, w, h)
end

-- Retrieve visible frame (without title bar) as four values:
--   local x, y, w, h = win:frame()
-- function lib:frame()

-- Set the window's visible frame (without title bar).
-- function lib:setFrame(x, y, w, h)

-- Get title bar height.
-- function lib.titleBarHeight()

-- Turn window resize/move animation on or off.
-- function lib:animateFrame(should_animate)

-- # Callbacks

-- Called whenever the window has been or is being moved.
-- The new position is passed as arguments.
-- function lib:moved(x, y)
--
-- Called when the window has been or is being resized.
-- The new size is passed as arguments.
-- function lib:resized(w, h)

return lib
