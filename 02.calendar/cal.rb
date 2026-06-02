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

firstday   = Date.new(year, month, 1)
lastday    = Date.new(year, month, -1).day
start_wday = firstday.wday

puts center_display("#{month}月 #{year}年", 20)
puts '日 月 火 水 木 金 土'

cells = ['  '] * start_wday + (1..lastday).map { |d| d.to_s.rjust(2) }
cells.each_slice(7) { |week| puts week.join(' ') }
