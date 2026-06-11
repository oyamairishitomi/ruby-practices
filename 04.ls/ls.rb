# frozen_string_literal: true

def fetch_files(path)
  Dir.entries(path).reject { |file| file.start_with?('.') }.sort
end

def display_files(files, max, item_len_max)
  height = (files.length.to_f / max).ceil
  height.times do |row|
    max.times do |col|
      item = files[row + col * height]
      print "#{item.to_s.ljust(item_len_max, ' ')}　" if item
    end
    puts ''
  end
end

path = ARGV[0] || '.'
files = fetch_files(path)
file_num = 3
lengths = files.map(&:length)
item_len_max = lengths.max
display_files(files, file_num, item_len_max)
