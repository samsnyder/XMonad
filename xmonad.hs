-- xmonad config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config

import System.IO
import System.Exit
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Util.EZConfig
import XMonad.Prompt
import XMonad.Prompt.Window

-- import Plugins.NotificationDaemon

-- http://xmonad.org/xmonad-docs/xmonad-contrib/XMonad-Util-EZConfig.html
myKeys = [
  ("<XF86AudioMute>", spawn "volume toggle"),
  ("<XF86AudioLowerVolume>", spawn "volume 2%-"),
  ("<XF86AudioRaiseVolume>", spawn "volume 2%+"),

  ("<XF86KbdBrightnessDown>", spawn "sudo keyboard-backlight down"),
  ("<XF86KbdBrightnessUp>", spawn "sudo keyboard-backlight up"),
  ("<XF86MonBrightnessDown>", spawn "sudo screen-backlight down"),
  ("<XF86MonBrightnessUp>", spawn "sudo screen-backlight up"),

  ("<XF86AudioPlay>", spawn "sp play"),
  ("<XF86AudioPrev>", spawn "sp prev"),
  ("<XF86AudioNext>", spawn "sp next"),

  ("M-<Escape>", spawn "lock"),
  ("M-v", spawn "notify-send Volume $(volume 0%+)"),
  ("M-g", spawn "notify-send Time $(date +\"%H:%M:%S\")"),

  ("M-p", spawn "gmrun"),

  ("M-d", windowPromptGoto defaultXPConfig { autoComplete = Just 500000 })
         ]

------------------------------------------------------------------------
-- Terminal
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal = "/usr/bin/sakura"

myNormalBorderColor  = "#7c7c7c"
myFocusedBorderColor = "#ffb6b0"


myWorkspaces = ["1:term","2:web","3:code", "4:media"] ++ map show [5..9]

myManageHook = composeAll
    [ className =? "Chromium"       --> doShift "2:web"
    , className =? "google-chrome"  --> doShift "2:web"
    , resource  =? "desktop_window" --> doIgnore
    , className =? "Galculator"     --> doFloat
    , className =? "Connman-gtk"    --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "gpicview"       --> doFloat
    , className =? "MPlayer"        --> doFloat
    , className =? "VirtualBox"     --> doShift "4:vm"
    , resource =? "spotify"          --> doShift "4:media"
    , className =? "stalonetray"    --> doIgnore
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]




myLayout = avoidStruts (
    ThreeColMid 1 (3/100) (1/2) |||
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    tabbed shrinkText tabConfig |||
    Full |||
    spiral (6/7)) |||
    noBorders (fullscreenFull Full)


tabConfig = defaultTheme {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}

myLayoutHook = smartBorders $ myLayout

------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()



-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"



------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
-- main = xmonad defaults

main = do
  xmproc <- spawnPipe "xmobar ~/.xmonad/xmobar.hs"
  xmonad $ defaultConfig {
    terminal = myTerminal,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,
    layoutHook         = myLayoutHook,
    manageHook         = myManageHook,
    workspaces         = myWorkspaces,
    logHook            = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = "   "
      }
    } `additionalKeysP` myKeys

------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = defaultConfig {
    -- simple stuff
    terminal           = myTerminal,
    startupHook        = myStartupHook
}

