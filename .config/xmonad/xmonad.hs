------------------------------------------------------
-- IMPORTS
------------------------------------------------------


-- Data
import Data.Char (isSpace, toUpper)
import qualified Data.Map as M
import Data.Maybe (fromJust, isJust)
import Data.Monoid


-- Base
import Graphics.X11.ExtraTypes.XF86
import System.Exit (exitSuccess)
import System.IO (hPutStrLn)


-- XMonad Base
import XMonad


-- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS
  ( Direction1D (..),
    WSType (..),
    moveTo,
    nextScreen,
    prevScreen,
    shiftTo,
  )
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.RotSlaves (rotAllDown, rotSlavesDown)
import qualified XMonad.Actions.Search as S
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (killAll, sinkAll)
import XMonad.Actions.CycleWS


-- Hooks
import XMonad.Hooks.DynamicLog
  ( PP (..),
    dynamicLogWithPP,
    shorten,
    wrap,
    xmobarColor,
    xmobarPP,
  )
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
  ( ToggleStruts (..),
    avoidStruts,
    docksEventHook,
    manageDocks,
  )
import XMonad.Hooks.ManageHelpers
  ( doCenterFloat,
    doFullFloat,
    isFullscreen,
  )
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

-- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid (Grid))
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows
  ( decreaseLimit,
    increaseLimit,
    limitWindows,
  )
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (EOT (EOT), mkToggle, single, (??))
import qualified XMonad.Layout.MultiToggle as MT (Toggle (..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (MIRROR, NBFULL, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns


-- Layouts modifiers
import qualified XMonad.Layout.ToggleLayouts as T
  ( ToggleLayout (Toggle),
    toggleLayouts,
  )
import XMonad.Layout.WindowArranger
  ( WindowArrangerMsg (..),
    windowArrange,
  )
import XMonad.Layout.WindowNavigation
import qualified XMonad.StackSet as W

-- Gnome
import XMonad.Config.Gnome

-- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce


-- Color Themes
import Colors.DoomOne
------------------------------------------------------
-- Constant Variables
------------------------------------------------------

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=11:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "alacritty"

myBrowser :: String
myBrowser = "firefox " -- Sets qutebrowser as browser

myBorderWidth :: Dimension
myBorderWidth = 2 -- Sets border width for windows

mySoundPlayer :: String
mySoundPlayer = "ffplay -nodisp -autoexit " -- The program that will play system sounds

windowCount :: X (Maybe String)
windowCount =
  gets $
    Just
      . show
      . length
      . W.integrate'
      . W.stack
      . W.workspace
      . W.current
      . windowset

myNormColor :: String -- Border color of normal windows
myNormColor = colorBack -- This variable is imported from Colors.THEME

myFocusColor :: String -- Border color of focused windows
myFocusColor = color15 -- This variable is imported from Colors.THEME

------------------------------------------------------
-- Autostart
------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
myStartupHook :: X ()
myStartupHook = do
  spawn "killall conky" -- kill current conky on each restart
  spawn "killall trayer" -- kill current trayer on each restart
  spawnOnce "nm-applet &"
  spawnOnce "volumeicon &"
  spawnOnce "blueman-applet &"
  spawnOnce "picom &"

  spawnOnce "cfw &"
  spawnOnce "nitrogen --restore &"
--  spawnOnce "lxappearance &"

  spawnOnce "/usr/bin/emacs --daemon &"

  spawn
    ( "sleep 2 && conky -c $HOME/.config/conky/xmonad/"
        ++ colorScheme
        ++ "-01.conkyrc"
    )

  spawn
    ( "sleep 2 && trayer --edge top --align right --widthtype request --padding 7 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 "
        ++ colorTrayer
        ++ " --height 22"
    )

------------------------------------------------------
-- Gridselect
------------------------------------------------------
myColorizer :: Window -> Bool -> X (String, String)
myColorizer =
  colorRangeFromClassName
    (0x28, 0x2c, 0x34) -- lowest inactive bg
    (0x28, 0x2c, 0x34) -- highest inactive bg
    (0xc7, 0x92, 0xea) -- active bg
    (0xc0, 0xa7, 0x9a) -- inactive fg
    (0x28, 0x2c, 0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer =
  ( buildDefaultGSConfig
      myColorizer
  )
    { gs_cellheight = 40,
      gs_cellwidth = 200,
      gs_cellpadding = 6,
      gs_originFractX = 0.5,
      gs_originFractY = 0.5,
      gs_font = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
  where
    conf =
      def
        { gs_cellheight = 40,
          gs_cellwidth = 200,
          gs_cellpadding = 6,
          gs_originFractX = 0.5,
          gs_originFractY = 0.5,
          gs_font = myFont
        }

myAppGrid =
  [ ("Audacity", "audacity"),
    ("Deadbeef", "deadbeef"),
    ("Emacs", "emacsclient -c -a emacs"),
    ("Firefox", "firefox"),
    ("Geany", "geany"),
    ("Geary", "geary"),
    ("Gimp", "gimp"),
    ("Kdenlive", "kdenlive"),
    ("LibreOffice Impress", "loimpress"),
    ("LibreOffice Writer", "lowriter"),
    ("OBS", "obs"),
    ("PCManFM", "pcmanfm")
  ]

------------------------------------------------------
-- Scratchpads
------------------------------------------------------
myScratchPads :: [NamedScratchpad]
myScratchPads =
  [ NS "terminal" spawnTerm findTerm manageTerm,
    NS "mocp" spawnMocp findMocp manageMocp,
    NS "calculator" spawnCalc findCalc manageCalc
  ]
  where
    spawnTerm = myTerminal ++ " -t scratchpad"

    findTerm = title =? "scratchpad"

    manageTerm = customFloating $ W.RationalRect l t w h
      where
        h = 0.9
        w = 0.9
        t = 0.95 - h
        l = 0.95 - w

    spawnMocp = myTerminal ++ " -t mocp -e mocp"

    findMocp = title =? "mocp"

    manageMocp = customFloating $ W.RationalRect l t w h
      where
        h = 0.9
        w = 0.9
        t = 0.95 - h
        l = 0.95 - w

    spawnCalc = "qalculate-gtk"

    findCalc = className =? "Qalculate-gtk"

    manageCalc = customFloating $ W.RationalRect l t w h
      where
        h = 0.5
        w = 0.4
        t = 0.75 - h
        l = 0.70 - w

------------------------------------------------------
-- Layouts
------------------------------------------------------
--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall =
  renamed [Replace "tall"] $
    smartBorders $
      windowNavigation $
        addTabs shrinkText myTabTheme $
          subLayout [] (smartBorders Simplest) $
            limitWindows 12 $
              mySpacing 8 $
                ResizableTall 1 (3 / 100) (1 / 2) []

--magnify =
--  renamed [Replace "magnify"] $
--    smartBorders $
--      windowNavigation $
--        addTabs shrinkText myTabTheme $
--          subLayout [] (smartBorders Simplest) $
--            magnifier $
--              limitWindows 12 $
--                mySpacing 8 $
--                  ResizableTall 1 (3 / 100) (1 / 2) []

monocle =
  renamed [Replace "monocle"] $
    smartBorders $
      windowNavigation $
        addTabs shrinkText myTabTheme $
          subLayout [] (smartBorders Simplest) $
            limitWindows 20 Full

floats =
  renamed [Replace "floats"] $ smartBorders $ limitWindows 20 simplestFloat

grid =
  renamed [Replace "grid"] $
    smartBorders $
      windowNavigation $
        addTabs shrinkText myTabTheme $
          subLayout [] (smartBorders Simplest) $
            limitWindows 12 $
              mySpacing 8 $
                mkToggle (single MIRROR) $
                  Grid (16 / 10)

spirals =
  renamed [Replace "spirals"] $
    smartBorders $
      windowNavigation $
        addTabs shrinkText myTabTheme $
          subLayout [] (smartBorders Simplest) $
            mySpacing' 8 $
              spiral (6 / 7)

threeCol =
  renamed [Replace "threeCol"] $
    smartBorders $
      windowNavigation $
        addTabs shrinkText myTabTheme $
          subLayout [] (smartBorders Simplest) $
            limitWindows 7 $
              ThreeCol 1 (3 / 100) (1 / 2)

threeRow =
  renamed [Replace "threeRow"] $
    smartBorders $
      windowNavigation $
        addTabs shrinkText myTabTheme $
          subLayout [] (smartBorders Simplest) $
            limitWindows 7
            -- Mirror takes a layout and rotates it by 90 degrees.
            -- So we are applying Mirror to the ThreeCol layout.
            $
              Mirror $
                ThreeCol 1 (3 / 100) (1 / 2)

tabs =
  renamed [Replace "tabs"]
  -- I cannot add spacing to this layout because it will
  -- add spacing between window and tabs which looks bad.
  $
    tabbed shrinkText myTabTheme

tallAccordion = renamed [Replace "tallAccordion"] Accordion

wideAccordion = renamed [Replace "wideAccordion"] $ Mirror Accordion

-- setting colors for tabs layout and tabs sublayout.
myTabTheme =
  def
    { fontName = myFont,
      activeColor = color15,
      inactiveColor = color08,
      activeBorderColor = color15,
      inactiveBorderColor = colorBack,
      activeTextColor = colorBack,
      inactiveTextColor = color16
    }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme =
  def
    { swn_font = "xft:Ubuntu:bold:size=60",
      swn_fade = 1.0,
      swn_bgcolor = "#1c1f24",
      swn_color = "#ffffff"
    }

-- The layout hook
myLayoutHook =
  avoidStruts $
    mouseResize $
      windowArrange $
        T.toggleLayouts floats $
          mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
    myDefaultLayout =
      withBorder myBorderWidth tall
        ||| noBorders monocle
        ||| floats
        ||| noBorders tabs
        ||| grid
        ||| spirals
        ||| threeCol
        ||| threeRow
        ||| tallAccordion
        ||| wideAccordion

------------------------------------------------------
-- Workspaces
------------------------------------------------------
-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
myWorkspaces =
  ["dev", "www", "sh", "misc", "sys", "mus", "chat", "vid", "game"]

myWorkspaceIndices = M.fromList $ zip myWorkspaces [1 ..] -- (,) == \x y -> (x,y)

clickable
  ws = "<action=xdotool key super+" ++ show i ++ ">" ++ ws ++ "</action>"
    where
      i = fromJust $ M.lookup ws myWorkspaceIndices

------------------------------------------------------
-- Managehook
------------------------------------------------------
-- Window rules:
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook =
  composeAll
    -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
    -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
    -- I'm doing it this way because otherwise I would have to write out the full
    -- name of my workspaces and the names would be very long if using clickable workspaces.
    [ (className =? "firefox" <&&> resource =? "Dialog") --> doFloat, -- Float Firefox Dialog
      className =? "file_progress" --> doFloat,
      className =? "Blueman-manager" --> doFloat,
      className =? "pinentry-gtk-2" --> doFloat,
      className =? "notification" --> doFloat,
      className =? "fcitx5-config-qt" --> doFloat,
      className =? "download" --> doFloat,
      className =? "toolbar" --> doFloat,
      className =? "confirm" --> doFloat,
      className =? "splash" --> doFloat,
      className =? "dialog" --> doFloat,
      className =? "error" --> doFloat,
      className =? "Steam" --> doFloat,
      className =? "Gimp" --> doFloat,
      title =? "Oracle VM VirtualBox Manager" --> doFloat,
      className =? "pavucontrol" --> doShift (myWorkspaces !! 4),
      className =? "filelight" --> doShift (myWorkspaces !! 4),
      className =? "blueman-manager" --> doShift (myWorkspaces !! 4),
      className =? "spotify" --> doShift (myWorkspaces !! 5) -- this line don't work and I don't know why
    ]
    <+> namedScratchpadManageHook myScratchPads

------------------------------------------------------
-- Keybindings
------------------------------------------------------
myKeys conf@XConfig {XMonad.modMask = modm} =
  M.fromList $
    -- launch a terminal
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf),
      -- launch rofi as run mode
      ((modm, xK_p), spawn "rofi -show drun"),
      -- Rotate through the available layout algorithms
      ((modm, xK_space), sendMessage NextLayout),
      -- Reset the layouts on the current workspace to default
      ((modm .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf),
      -- Resize viewed windows to the correct size
      ((modm, xK_n), refresh),

      -- close focused window
      ((modm .|. shiftMask, xK_c), kill),
      -- Move focus to the next window
      ((modm, xK_Tab), windows W.focusDown),
      -- Move focus to the next window
      ((modm, xK_j), windows W.focusDown),
      -- Move focus to the previous window
      ((modm, xK_k), windows W.focusUp),
      -- Move focus to the master window
      ((modm, xK_m), windows W.focusMaster),
      -- Swap the focused window and the master window
      ((modm .|. shiftMask, xK_Return), windows W.swapMaster),
      -- Swap the focused window with the next window
      ((modm .|. shiftMask, xK_j), windows W.swapDown),
      -- Swap the focused window with the previous window
      ((modm .|. shiftMask, xK_k), windows W.swapUp),

      -- Navigate to next workspace
      ((modm, xK_Right),  nextWS),
      -- Navigate to previous workspace
      ((modm, xK_Left),  prevWS),
      -- Send current windows to next workspace and follow the moving
      ((modm .|. shiftMask, xK_Right), shiftToNext >> nextWS),
      -- Send current windows to prev workspace and follow the moving
      ((modm .|. shiftMask, xK_Left), shiftToPrev >> prevWS),
      ((modm, xK_Down), nextScreen),
      ((modm, xK_Up),  prevScreen),
      ((modm .|. shiftMask, xK_Down), shiftNextScreen),
      ((modm .|. shiftMask, xK_Up),  shiftPrevScreen),
      -- Toggle most recently visited workspace
      ((modm, xK_z), toggleWS),
      -- find a free workspace
      ((modm, xK_d), moveTo Next emptyWS),

      -- Shrink the master area
      ((modm, xK_h), sendMessage Shrink),
      -- Expand the master area
      ((modm, xK_l), sendMessage Expand),
      -- Push window back into tiling
      ((modm, xK_t), withFocused $ windows . W.sink),
      -- Increment the number of windows in the master area
      ((modm, xK_comma), sendMessage (IncMasterN 1)),
      -- Deincrement the number of windows in the master area
      ((modm, xK_period), sendMessage (IncMasterN (-1))),

      -- Toggle the status bar gap
      -- Use this binding with avoidStruts from Hooks.ManageDocks.
      -- See also the statusBar function from Hooks.DynamicLog.
      --((modm, xK_b), sendMessage ToggleStruts),

      -- Quit xmonad
      ((modm .|. shiftMask, xK_q), io exitSuccess),
      -- Restart xmonad
      ( (modm, xK_q),
        spawn "  killall xmobar; xmonad --recompile; xmonad --restart"
      ),

      -- Run xmessage with a summary of the default keybindings (useful for beginners)
      ( (modm .|. shiftMask, xK_slash),
        spawn ("echo \"" ++ help ++ "\" | xmessage -file -")
      ),
    
      -- Custom applications
      ((modm, xK_f), spawn myBrowser), -- Launch Browser(Firefox)
      ((modm, xK_c), spawn "code"), -- Lauch vs code
      ((modm, xK_e), spawn "emacs"), -- Lauch vs code
      ((modm, xK_i), spawn "gnome-control-center"), -- Lauch gnome settings
      --((modm, xK_l), spawn "slock"), -- Lauch gnome settings

      -- Hardware Control
      ((0, xF86XK_MonBrightnessUp), spawn "brightnessctl set +5%"), -- brightness up
      ((0, xF86XK_MonBrightnessDown), spawn "brightnessctl set 5%-") -- brightness down
      ]
      ++
      -- mod-[1..9], Switch to workspace N
      -- mod-shift-[1..9], Move client to workspace N
      [ ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]
      -- ++
      -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
      -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
      --
      --[ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
      --  | (key, sc) <- zip [xK_w, xK_e, xK_r] [0 ..],
      --    (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
      --]

myKeys2 :: [(String, X ())]
myKeys2  =
    -- launch a terminal
    [
      ("M-<Return>", spawn (myTerminal)),
      -- Run rofi
      ("M-p", spawn "rofi -show drun"), 
      -- Kill the currently focused client
      ("M-S-c", kill),
      -- Kill all windows on current workspace
      ("M-S-a", killAll),
      -- Rotate through the available layout algorithms
      ("M-<Space>", sendMessage NextLayout),
      --  Reset the layouts on the current workspace to default
      --("M-S-<Space>", setLayout $ XMonad.layoutHook conf),
      -- Resize viewed windows to the correct size
      ("M-n", refresh),
      -- Move focus to the next window
      ("M-<Tab>", windows W.focusDown),
      -- Move focus to the next window
      ("M-j", windows W.focusDown),
      -- Move focus to the previous window
      ("M-k", windows W.focusUp),
      -- Move focus to the master window
      ("M-m", windows W.focusMaster),
      -- Swap the focused window and the master window
      ("M-S-<Return>", windows W.swapMaster),
      -- Swap the focused window with the next window
      ("M-S-j", windows W.swapDown),
      -- Swap the focused window with the previous window
      ("M-S-k", windows W.swapUp),
      -- Shrink the master area
      ("M-h", sendMessage Shrink),
      -- Expand the master area
      ("M-l", sendMessage Expand),
      -- Push window back into tiling
      ("M-t", withFocused $ windows . W.sink),
      -- Increment the number of windows in the master area
      ("M-S-<Up>", sendMessage (IncMasterN 1)),
      -- Deincrement the number of windows in the master area
      ("M-S-<Down>", sendMessage (IncMasterN (-1))),
      -- Toggle the status bar gap
      -- Use this binding with avoidStruts from Hooks.ManageDocks.
      -- See also the statusBar function from Hooks.DynamicLog.
      ("M-b", sendMessage ToggleStruts),
      -- Quit xmonad
      ("M-S-q", io exitSuccess),
      -- Restart xmonad
      ("M-q", spawn "  killall xmobar; xmonad --recompile; xmonad --restart"),
      -- Run xmessage with a summary of the default keybindings (useful for beginners)
      ( "M-S-/", spawn ("echo \"" ++ help ++ "\" | xmessage -fn '-*-*-*-r-*--35-0-0-0-p-*-*-*' -file -")),

      -- Custom applications
      ("M-f", spawn "firefox"), -- Launch Firefox
      ("M-c", spawn "code"), -- Lauch vs code
      ("M-e e", spawn "emacs"), -- Lauch vs code
      ("M-i", spawn "gnome-control-center"), -- Lauch gnome settings

      -- Hardware Control
     ("<XF86MonBrightnessUp>", spawn "brightnessctl set +5%"), -- brightness up
     ("<XF86MonBrightnessDown>", spawn "brightnessctl set 5%-") -- brightness down
    ]

-- Mouse bindings: default actions bound to mouse events
myMouseBindings XConfig {XMonad.modMask = modm} =
  M.fromList
    [ ( (modm, button1),
        \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), \w -> focus w >> windows W.shiftMaster),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster
      )
    ]

------------------------------------------------------
-- Main
------------------------------------------------------
-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = True

------------------------------------------------------------------------
main = do
  -- Launching three instances of xmobar on their monitors.
  xmproc0 <-
    spawnPipe
      ("xmobar -x 0 $HOME/.config/xmobar/" ++ colorScheme ++ "-xmobarrc-0.hs")
  xmproc1 <-
    spawnPipe
      ("xmobar -x 1 $HOME/.config/xmobar/" ++ colorScheme ++ "-xmobarrc-0.hs")
  xmonad $
    ewmh
      def -- simple stuff
        { manageHook = myManageHook <+> manageDocks,
          handleEventHook = docksEventHook,
          modMask = myModMask,
          terminal = myTerminal,
          startupHook = myStartupHook,
          layoutHook = showWName' myShowWNameTheme myLayoutHook,
          workspaces = myWorkspaces,
          borderWidth = myBorderWidth,
          normalBorderColor = myNormColor,
          focusedBorderColor = myFocusColor,
          focusFollowsMouse = myFocusFollowsMouse,
          logHook =
            dynamicLogWithPP $
              namedScratchpadFilterOutWorkspacePP $
                xmobarPP -- XMOBAR SETTINGS
                  { ppOutput = \x ->
                      hPutStrLn xmproc0 x -- xmobar on monitor 1
                      >> hPutStrLn xmproc1 x, -- xmobar on monitor 2
                      -- Current workspace
                    ppCurrent =
                      xmobarColor color06 ""
                        . wrap
                          ("<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">")
                          "</box>",
                    -- Visible but not current workspace
                    ppVisible = xmobarColor color06 "" . clickable,
                    -- Hidden workspace
                    ppHidden =
                      xmobarColor color05 ""
                        . wrap
                          ("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">")
                          "</box>"
                        . clickable,
                    -- Hidden workspaces (no windows)
                    ppHiddenNoWindows = xmobarColor color05 "" . clickable,
                    -- Title of active window
                    ppTitle = xmobarColor color16 "" . shorten 60,
                    -- Separator character
                    ppSep = "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>",
                    -- Urgent workspace
                    ppUrgent = xmobarColor color02 "" . wrap "!" "!",
                    -- Adding # of windows on current workspace to the bar
                    ppExtras = [windowCount],
                    -- order of things in xmobar
                    ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex ++ [t]
                  },
          clickJustFocuses = myClickJustFocuses,
          -- key bindings
          keys = myKeys,
          mouseBindings = myMouseBindings
        }

------------------------------------------------------
-- Help
------------------------------------------------------

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help =
  unlines
    [ "The default modifier key is 'alt'. Default keybindings:",
      "",
      "-- launching and killing programs",
      "mod-Enter        Launch terminal",
      "mod-p            Launch rofi -show run",
      "mod-Shift-c      Close/kill the focused window",
      "mod-Space        Rotate through the available layout algorithms",
      "mod-Shift-Space  Reset the layouts on the current workSpace to default",
      "mod-n            Resize/refresh viewed windows to the correct size",
      "",
      "-- move focus up or down the window stack",
      "mod-Tab        Move focus to the next window",
      "mod-Shift-Tab  Move focus to the previous window",
      "mod-j          Move focus to the next window",
      "mod-k          Move focus to the previous window",
      "mod-m          Move focus to the master window",
      "",
      "-- modifying the window order",
      "mod-Return   Swap the focused window and the master window",
      "mod-Shift-j  Swap the focused window with the next window",
      "mod-Shift-k  Swap the focused window with the previous window",
      "",
      "-- resizing the master/slave ratio",
      "mod-h  Shrink the master area",
      "mod-l  Expand the master area",
      "",
      "-- floating layer support",
      "mod-t  Push window back into tiling; unfloat and re-tile it",
      "",
      "-- increase or decrease number of windows in the master area",
      "mod-comma  (mod-,)   Increment the number of windows in the master area",
      "mod-period (mod-.)   Deincrement the number of windows in the master area",
      "",
      "-- quit, or restart",
      "mod-Shift-q  Quit xmonad",
      "mod-q        Restart xmonad",
      "mod-[1..9]   Switch to workSpace N",
      "",
      "-- Workspaces & screens",
      "mod-Shift-[1..9]   Move client to workspace N",
      "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
      "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
      "",
      "-- Mouse bindings: default actions bound to mouse events",
      "mod-button1  Set the window to floating mode and move by dragging",
      "mod-button2  Raise the window to the top of the stack",
      "mod-button3  Set the window to floating mode and resize by dragging"
    ]
