# frozen_string_literal: true
require 'optparse'

MAX_COLUMN_NUMBER = 3

options = ARGV.('a')

def fetch_files(path, all)
  if all
    Dir.entries(path).sort
  else
    Dir.entries(path).reject { |file| file.start_with?('.') }.sort
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

path = ARGV[0] || '.'
files = fetch_files(path, options['a'])
display_files(files)
