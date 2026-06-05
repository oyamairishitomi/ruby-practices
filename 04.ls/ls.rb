# frozen_string_literal: true

def fetch_files(path)
  Dir.entries(path).reject { |file| file.start_with?('.') }.sort
end

def display_files(files, max)
  height = (files.length.to_f / max).ceil
  height.times do |row|
    max.times do |col|
      item = files[row + col * height]
      print "#{item}　" if item
    end
    puts ''
  end
end

path = ARGV[0] || '.'
files = fetch_files(path)
display_files(files, 3)
