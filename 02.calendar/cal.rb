#!/usr/bin/env ruby

require 'date'
require 'optparse'

def display_width(str)
  str.each_char.sum { |c| c.bytesize > 1 ? 2 : 1 }
end

def center_display(str, width)
  pad = [width - display_width(str), 0].max
  ' ' * (pad / 2) + str
end

options = {}
OptionParser.new do |opts|
  opts.on('-m MONTH', Integer) { |m| options[:month] = m }
  opts.on('-y YEAR', Integer)  { |y| options[:year] = y }
end.parse!

today = Date.today
year  = options[:year]  || today.year
month = options[:month] || today.month

firstday = Date.new(year, month, 1)
lastday  = Date.new(year, month, -1).day

title   = "#{month}月 #{year}年"
weekday = '日 月 火 水 木 金 土'
brank   = firstday.wday

puts center_display(title, 20)
puts weekday

brank.times { print '   ' }

(1..lastday).each do |day|
  if Date.new(year, month, day).wday == 6
    print day.to_s.rjust(2) + "\n"
  else
    print day.to_s.rjust(2) + ' '
  end
end

print "\n" unless Date.new(year, month, lastday).wday == 6
