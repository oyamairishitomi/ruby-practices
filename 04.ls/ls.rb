# frozen_string_literal: true

require 'optparse'
require 'fileutils'
require 'etc'

MAX_COLUMN_NUMBER = 3
PERMISSION_TABLE = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'].freeze

def get_files(path)
  Dir.entries(path).reject { |file| file.start_with?('.') }
end

def type_char(path)
  filetype = File.stat(path).ftype
  if filetype == 'directory'
    'd'
  elsif filetype == 'link'
    'l'
  else
    '-'
  end
end

def permission_string(path)
  digits = File.stat(path).mode.to_s(8)[-3..]
  digits.each_char.map { |char| PERMISSION_TABLE[char.to_i] }.join
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

options = ARGV.getopts('rl')
path = ARGV[0] || '.'
files = fetch_files(path, options)

if options['l']
  sum = 0
  files.each do |file|
    sum += File.stat(File.join(path, file)).blocks
  end
  puts "total #{sum / 2}"
  files.each do |file|
    full_path = File.join(path, file)
    stat = File.stat(full_path)
    owner = Etc.getpwuid(stat.uid).name
    group = Etc.getgrgid(stat.gid).name
    mtime = stat.mtime.strftime('%b %e %H:%M')
    puts "#{type_char(full_path)}#{permission_string(full_path)} #{stat.nlink} #{owner} #{group} #{stat.size} #{mtime} #{file}"
  end
else
  display_files(files)
end
