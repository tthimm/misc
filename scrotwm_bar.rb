#!/usr/bin/env ruby
#
# displays current date, time and song played via mpd/mpc in scrotwm bar
#
# mpd:     http://mpd.wikia.com/wiki/Music_Player_Daemon_Wiki
# mpc:     http://mpd.wikia.com/wiki/Client:Mpc
# scrotwm: http://www.scrotwm.org/
#
# add in ~/.scrotwm.conf:
#   bar_action = /path/to/scrotwm_bar.rb
#   bar_delay = 5
#
# and run:
#   chmod u+x /path/to/scrotwm_bar.rb
#
require 'date'

SHOW_CLOCK = true
SHOW_MPD_SONG = true

def time_and_date
  return nil unless SHOW_CLOCK
  return "#{Date.today} | #{Time.now.strftime('%H:%M')}"
end

def mpd_song
  return nil unless SHOW_MPD_SONG
  status_and_song = nil
  match = %r(\A(?:.+:\s(.+)|\A(.+))\n(\[.+\])).match(%x(mpc status))
  if match then
    match = match.captures.compact
    status_and_song = "#{match.last} #{match.first}"
  end
  return status_and_song
end

STDOUT.sync = true
while true do
  puts [time_and_date, mpd_song].compact.join(" | ")
  sleep 1
end
