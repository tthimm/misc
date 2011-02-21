#!/usr/bin/env ruby

#  0    turn off all attributes
#  1    bold mode
#  4    underline mode
#  5    blink mode (not available in xterm)
#  7    invert colors
#
# FG|BG
# 30|40 black
# 31|41 red
# 32|42 green
# 33|43 yellow
# 34|44 blue
# 35|45 magenta
# 36|46 cyan
# 37|47 white
#
# examples:
# black on white = "\e[30;47m"
# white on black = "\e[37;40m"
# black          = "\[30m"

class String

  def to_colored(col)
    color = {
      :black        => "\e[30m",
      :bold_black   => "\e[1;30m",
      :red          => "\e[31m",
      :bold_red     => "\e[1;31m",
      :green        => "\e[32m",
      :bold_green   => "\e[1;32m",
      :yellow       => "\e[33m",
      :bold_yellow  => "\e[1;33m",
      :blue         => "\e[34m",
      :bold_blue    => "\e[1;34m",
      :magenta      => "\e[35m",
      :bold_magenta => "\e[1;35m",
      :cyan         => "\e[36m",
      :bold_cyan    => "\e[1;36m",
      :white        => "\e[37m",
      :bold_white   => "\e[1;37m",
      :bold         => "\e[1m",
      :inverted     => "\e[7m"
    }
    return "#{color[col]}#{self}#{reset_color}"
  end
  
  def reset_color
    return "\e[0m"
  end


end


class CliSearch

  def initialize(search_string=nil)
    @search_string = search_string.nil? ? pattern_from_stdin : search_string
    @color = search_string.nil? ? true : false
  end

  def perform_search
    if @search_string then
      color_for_result = colored_output? ? "--color=always" : ""
      result = `grep -IrinE #{color_for_result} --exclude-dir='./.git' --exclude-dir='./log' '#{@search_string}' .`
      return (result.empty? ? "#{@search_string.to_colored(:bold_magenta)}: not found!" : result) if colored_output?
      return (result.empty? ? "'#{@search_string}' not found!" : result) unless colored_output?
    else
      return "Error".to_colored(:bold_red) + ": Search string required" if colored_output?
      return "Error: Search string required" unless colored_output?
    end
  end

  def pattern_from_stdin
    unless ARGV.empty? then
      return ARGV.join(" ")
    else
      return false
    end
  end

  def colored_output?
    return @color
  end


end

search = CliSearch.new
result = search.perform_search
puts result

