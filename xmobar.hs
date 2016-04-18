-- xmobar config used by Vic Fryzel
-- Author: Vic Fryzel
-- http://github.com/vicfryzel/xmonad-config


-- This is setup for dual 1920x1080 monitors, with the right monitor as primary
Config {
    font = "xft:Fixed-8",
    bgColor = "#000000",
    fgColor = "#ffffff",
    -- position = Static { xpos = 0, ypos = 0, width = 2560, height = 16 },
    position = TopSize C 100 40
    lowerOnStart = True,
    commands = [
        Run MultiCpu ["-t","Cpu: <total0> <total1> <total2> <total3>","-L","30","-H","60","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC","-w","3"] 10,
        Run Memory ["-t","Mem: <usedratio>%","-H","8192","-L","4096","-h","#FFB6B0","-l","#CEFFAC","-n","#FFFFCC"] 10,
        Run Date "%a %b %_d %l:%M" "date" 10,
        Run StdinReader,
        Run CommandReader  "tail -F ~/.xmonad/xmobar-notif" "notif",
        Run BatteryP ["BAT0"] ["-t", "<left>% (<timeleft>)"] 600,
        Run Wireless "wlan0" ["-t", "<essid>"] 60,
        -- Run Mpris2 "spotify" ["-t", "<title> - <artist>"] 10,
        Run Com "pretty_spot.sh" [] "spotify" 10
        -- Run CommandReader  "tail -f " "notif"
        -- Run NotificationDaemon 75 100 20000 5000,
    ],
    sepChar = "%",
    alignSep = "}{",
    template = "%StdinReader%}{ <fc=#999999>%spotify%</fc> %battery% <action=`wifi` button=12345>%wlan0wi%</action>  <fc=#FFFFCC>%date%</fc>"
}
