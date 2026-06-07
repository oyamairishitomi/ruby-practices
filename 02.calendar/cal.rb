#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-m MONTH', Integer) { |m| options[:month] = m }
  opts.on('-y YEAR', Integer) { |y| options[:year] = y }
end.parse!

today = Date.today
year = options[:year] || today.year
month = options[:month] || today.month

first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

puts "      #{month}月 #{year}"
puts '日 月 火 水 木 金 土'
print '   ' * first_date.wday

(first_date..last_date).each do |date|
  day = date.day.to_s.rjust(2)
  if date.saturday? || date == last_date
    puts day
  else
    print "#{day} "
  end
end
