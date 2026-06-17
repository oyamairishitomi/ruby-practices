# frozen_string_literal: true
require 'optparse'

MAX_COLUMN_NUMBER = 3

def get_files(path)
  Dir.entries(path).reject { |file| file.start_with?('.') }
end

def fetch_files(path, options)
  if options['r']
    get_files(path).sort.reverse
  else
    get_files(path).sort
  end
end

def display_files(files)
  item_len_max = files.map(&:length).max
  height = (files.length.to_f / MAX_COLUMN_NUMBER).ceil
  height.times do |row|
    MAX_COLUMN_NUMBER.times do |col|
      item = files[row + col * height]
      print "#{item.to_s.ljust(item_len_max, ' ')}　" if item
    end
    puts ''
  end
end

options = ARGV.getopts('r')
path = ARGV[0] || '.'
files = fetch_files(path, options)
display_files(files)
