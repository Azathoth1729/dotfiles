-- Xmobar (http://projects.haskell.org/xmobar/)

-- Color scheme: Doom One

-- Dependencies:
-- alacritty
-- htop
-- emacs
-- pacman (Arch Linux)
-- trayer

Config
  { font = "xft:Source Code Pro:weight=bold:pixelsize=22:antialias=true:hinting=true",
    additionalFonts =
      [ "xft:Noto Sans CJK SC:pixelsize=18:antialias=true:hinting=true"
      ],
    bgColor = "#282c34",
    fgColor = "#ff6c6b",
    -- Position TopSize and BottomSize take 3 arguments:
    -- an alignment parameter (L/R/C) for Left, Right or Center.
    -- an integer for the percentage width, so 100 would be 100%.
    -- an integer for the minimum pixel height for xmobar, so 24 would force a height of at least 24 pixels.
    -- NOTE: The height should be the same as the trayer (system tray) height.
    position = TopSize L 100 24,
    lowerOnStart = True,
    hideOnStart = False,
    allDesktops = True,
    persistent = True,
    iconRoot = "/home/azathoth/.xmonad/xpm/", -- default: "."
    commands =
      [ -- Get kernel version (script found in .local/bin)
        Run Com ".local/bin/kernel" [] "kernel" 36000,
        -- Cpu usage in percent
        Run Cpu ["-t", "<icon=cpu_20.xpm/> \xf133 cpu: (<total>%) ", "-H", "50", "--high", "red"] 20,
        -- Ram used number and percent
        Run Memory ["-t", "<icon=memory-icon_20.xpm/> mem: <used>M (<usedratio>%) "] 20,
        -- Uptime
        Run Uptime ["-t", "<icon=net_up_20.xpm/>uptime: <days>d <hours>h "] 360,
        -- Check for pacman updates (script found in .local/bin)
        Run Com ".local/bin/pacupdate" [] "pacupdate" 36000,
        -- Battery
        Run
          BatteryP
          ["BAT1"]
          [ "-t",
            "Charging <acstatus>",
            "-L",
            "20",
            "-H",
            "80",
            "-l",
            "#ff6c6b",
            "-h",
            "#da8548",
            "--",
            "-O",
            "Charging",
            "-o",
            "Battery: <timeleft> (<left>%)"
          ]
          360,
        -- Time and date
        Run Date "<icon=calendar-clock-icon_20.xpm/> %b %d %Y - (%H:%M) " "date" 50,
        -- Script that dynamically adjusts xmobar padding depending on number of trayer icons.
        Run Com ".config/xmobar/trayer-padding-icon.sh" [] "trayerpad" 20,
        -- Prints out the left side items such as workspaces, layout, etc.
        Run UnsafeStdinReader
      ],
    sepChar = "%",
    alignSep = "}{",
    template =
      "<action=`dm-run`><icon=haskell_20.xpm/></action>\
      \<fc=#666666>|</fc> %UnsafeStdinReader%\
      \}{\
      \<box type=Bottom width=2 mb=2 color=#51afef>\
      \<fc=#51afef>%kernel%</fc>\
      \</box>\
      \<box type=Bottom width=2 mb=2 color=#ecbe7b>\
      \<fc=#ecbe7b>\
      \<action=`alacritty -e htop`>%cpu%</action>\
      \</fc>\
      \</box>\
      \<box type=Bottom width=2 mb=2 color=#ff6c6b>\
      \<fc=#ff6c6b>\
      \<action=`htop`>%memory%</action>\
      \</fc>\
      \</box>\
      \<box type=Bottom width=2 mb=2 color=#98be65>\
      \<fc=#98be65>%uptime%</fc>\
      \</box>\
      \<box type=Bottom width=2 mb=2 color=#c678dd>\
      \<fc=#c678dd>\
      \<action=`alacritty -e sudo pacman -Syu`>%pacupdate%</action>\
      \</fc>\
      \</box>\
      \<box type=Bottom width=2 mb=2 color=#da8548>\
      \<fc=#da8548>%battery%</fc>\
      \</box>\
      \<box type=Bottom width=2 mb=2 color=#46d9ff>\
      \<fc=#46d9ff>\
      \%date%\
      \</fc>\
      \</box>\
      \%trayerpad%"
  }
