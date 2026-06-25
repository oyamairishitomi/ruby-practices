# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_COLUMN_NUMBER = 3
PERMISSION_TABLE = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'].freeze
COLUMN_KEYS = %i[nlink owner group size].freeze

def get_files(path, all)
  entries = Dir.entries(path).sort

  if all
    entries
  else
    entries.reject { |file| file.start_with?('.') }
  end
end

def permission_string(stat)
  digits = stat.mode.to_s(8)[-3..]
  digits.each_char.map { |char| PERMISSION_TABLE[char.to_i] }.join
end

def fetch_files(path, options)
  files = get_files(path, options['a'])
  files = files.reverse if options['r']
  files
end

def type_char(stat)
  case stat.ftype
  when 'directory' then 'd'
  when 'link' then 'l'
  else '-'
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

def column_width(file_details)
  COLUMN_KEYS.map do |k|
    file_details.map { |detail| detail[k].length }.max
  end
end

def display_file_details(file_details)
  puts "total #{file_details.sum { |detail| detail[:blocks] } / 2}"

  nlink_width, owner_width, group_width, size_width = column_width(file_details)

  file_details.each do |detail|
    nlink = detail[:nlink].rjust(nlink_width)
    owner = detail[:owner].rjust(owner_width)
    group = detail[:group].rjust(group_width)
    size = detail[:size].rjust(size_width)
    puts "#{detail[:permission]} #{nlink} #{owner} #{group} #{size} #{detail[:mtime]} #{detail[:name]}"
  end
end

options = ARGV.getopts('arl')
path = ARGV[0] || '.'
files = fetch_files(path, options)

if options['l']
  file_details = files.map do |file|
    full_path = File.join(path, file)
    stat = File.lstat(full_path)
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
  display_file_details(file_details)
else
  display_files(files)
end