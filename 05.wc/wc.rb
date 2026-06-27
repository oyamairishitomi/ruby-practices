# frozen_string_literal: true

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-l') { options[:l] = true }
  opts.on('-w') { options[:w] = true }
  opts.on('-c') { options[:c] = true }
end.parse!(ARGV)

line_counts = []
word_counts = []
byte_sizes = []

if ARGV.empty?
  content = $stdin.read
  line_counts << content.lines.count
  word_counts << content.split.count
  byte_sizes << content.bytesize
else
  ARGV.each do |file_name|
    content = File.read(file_name)
    line_counts << content.lines.count
    word_counts << content.split.count
    byte_sizes << content.bytesize
  end
end

max_len = ([line_counts.sum, word_counts.sum, byte_sizes.sum] + line_counts + word_counts + byte_sizes).max.to_s.length

def format_counts(datam, options, max_len)
  line, word, byte = datam
  values = []
  values << line.to_s.rjust(max_len) if options[:l] || options.empty?
  values << word.to_s.rjust(max_len) if options[:w] || options.empty?
  values << byte.to_s.rjust(max_len) if options[:c] || options.empty?
  values.join(' ')
end

if ARGV.empty?
  puts format_counts([line_counts[0], word_counts[0], byte_sizes[0]], options, max_len)
else
  ARGV.each_with_index do |file_name, i|
    puts "#{format_counts([line_counts[i], word_counts[i], byte_sizes[i]], options, max_len)} #{file_name}"
  end
end

puts "#{format_counts([line_counts.sum, word_counts.sum, byte_sizes.sum], options, max_len)} total" if ARGV.size > 1
