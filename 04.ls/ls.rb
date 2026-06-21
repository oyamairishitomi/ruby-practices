# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_COLUMN_NUMBER = 3
PERMISSION_TABLE = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'].freeze

def get_files(path)
  Dir.entries(path).reject { |file| file.start_with?('.') }
end

def type_char(stat)
  case stat.ftype
  when 'directory' then 'd'
  when 'link' then 'l'
  else '-'
  end
end

def permission_string(stat)
  digits = stat.mode.to_s(8)[-3..]
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
  file_details = files.map do |file|
    full_path = File.join(path, file)
    stat = File.stat(full_path)
    {
      permission: "#{type_char(stat)}#{permission_string(stat)}",
      nlink: stat.nlink.to_s,
      owner: Etc.getpwuid(stat.uid).name,
      group: Etc.getgrgid(stat.gid).name,
      size: stat.size.to_s,
      mtime: stat.mtime.strftime('%b %e %H:%M'),
      name: file,
      blocks: stat.blocks
    }
  end

  puts "total #{file_details.sum { |d| d[:blocks] } / 2}"

  nlink_width = file_details.map { |d| d[:nlink].length }.max
  owner_width = file_details.map { |d| d[:owner].length }.max
  group_width = file_details.map { |d| d[:group].length }.max
  size_width = file_details.map { |d| d[:size].length }.max

  file_details.each do |d|
    nlink = d[:nlink].rjust(nlink_width)
    owner = d[:owner].rjust(owner_width)
    group = d[:group].rjust(group_width)
    size = d[:size].rjust(size_width)
    puts "#{d[:permission]} #{nlink} #{owner} #{group} #{size} #{d[:mtime]} #{d[:name]}"
  end
else
  display_files(files)
end
