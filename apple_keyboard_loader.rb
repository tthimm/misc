#!/usr/bin/env ruby
#
# layout for qwertz apple aluminium keyboard
# loads config if keyboard is connected
#
# uses notify-send if installed (libnotify-bin)
#
# change fn key behavior
# as root add to /etc/rc.local:
#   echo 2 > /sys/module/hid_apple/parameters/fnmode
#
# description of behavior
# example for f8, but it works for f1-f12
# 0 - disables fn key
# 1 - press f8 for special key(play/pause), fn+f8 for f8
# 2 - press f8 for f8, fn+f8 for special key(play/pause)
#
require 'fileutils'

class Keyboard
  def apple_keyboard_connected?
    file = "/proc/bus/input/devices"
    if File.exists?(file) then
      text = IO.read(file)
      match = /Apple\,\sInc\sApple\sKeyboard/.match(text)
      return !match.to_a.empty?
    end
  end

  def load_apple_config
    %x(xmodmap -e 'keycode 94 = dead_circumflex degree dead_circumflex degree U2032 U2033 U2032' -e 'keycode 49 = less greater less greater bar brokenbar bar' -e 'keycode 37 = Control_L' -e 'keycode 133 = Alt_L Meta_L' -e 'keycode 64 = Super_L' -e 'keycode 108 = Super_R' -e 'keycode 134 = ISO_Level3_Shift Multi_key' -e 'keycode 105 = Control_R Multi_key' -e 'clear Shift' -e 'clear Lock' -e 'clear Control' -e 'clear Mod1' -e 'clear Mod2' -e 'clear Mod3' -e 'clear Mod4' -e 'clear Mod5' -e 'add Shift = Shift_L Shift_R' -e 'add Lock = Caps_Lock' -e 'add Control = Control_L Control_R' -e 'add Mod1 = Alt_L 0x007D' -e 'add Mod2 = Num_Lock' -e 'add Mod4 = Super_L Super_R' -e 'add Mod5 = Mode_switch ISO_Level3_Shift ISO_Level3_Shift ISO_Level3_Shift')
    return "apple"
  end

  def load_default_config
    %x(xmodmap -e 'clear shift' -e 'clear lock' -e 'clear control' -e 'clear mod1' -e 'clear mod2' -e 'clear mod3' -e 'clear mod4' -e 'clear mod5' -e 'keycode 37 = Control_L' -e 'keycode 133 = Super_L' -e 'keycode 64 = Alt_L' -e 'keycode 108 = ISO_Level3_Shift' -e 'keycode 50 = Shift_L' -e 'keycode 62 = Shift_R' -e 'keycode 105 = Control_R' -e 'keycode 66 = Caps_Lock' -e 'add Shift = Shift_L Shift_R' -e 'add Lock = Caps_Lock' -e 'add Control = Control_L Control_R')
    return "default"
  end

  def load_config
    if apple_keyboard_connected? then
      config_name = load_apple_config
    else
      config_name = load_default_config
    end
    if File.exists?("/usr/bin/notify-send") then
      %x(notify-send -t 2500 "Keyboard:" "#{config_name} config loaded")
    else
      puts "Keyboard: #{config_name} config loaded"
    end
  end


end

keyboard = Keyboard.new
keyboard.load_config

