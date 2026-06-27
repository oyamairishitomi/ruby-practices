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

max_len = (line_counts + word_counts + byte_sizes).max.to_s.length
options[:max_len] = max_len

def format_counts(line, word, byte, options)
  values = []
  values << line.to_s.rjust(options[:max_len]) if options[:l] || options.except(:max_len).empty?
  values << word.to_s.rjust(options[:max_len]) if options[:w] || options.except(:max_len).empty?
  values << byte.to_s.rjust(options[:max_len]) if options[:c] || options.except(:max_len).empty?
  values.join(' ')
end

if ARGV.empty?
  puts format_counts(line_counts[0], word_counts[0], byte_sizes[0], options)
else
  ARGV.each_with_index do |file_name, i|
    puts "#{format_counts(line_counts[i], word_counts[i], byte_sizes[i], options)} #{file_name}"
  end
end

puts "#{format_counts(line_counts.sum, word_counts.sum, byte_sizes.sum, options)} total" if ARGV.size > 1
