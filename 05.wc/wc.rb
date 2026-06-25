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

max_len = if ARGV.size > 1
            (line_counts + word_counts + byte_sizes).max.to_s.length
          else
            0
          end

def format_counts(line, word, byte, max_len, options)
  values = []
  values << line.to_s.rjust(max_len) if options[:l] || options.empty?
  values << word.to_s.rjust(max_len) if options[:w] || options.empty?
  values << byte.to_s.rjust(max_len) if options[:c] || options.empty?
  values.join(' ')
end

if ARGV.empty?
  puts format_counts(line_counts[0], word_counts[0], byte_sizes[0], max_len, options)
else
  ARGV.each_with_index do |file_name, i|
    puts "#{format_counts(line_counts[i], word_counts[i], byte_sizes[i], max_len, options)} #{file_name}"
  end
end

puts "#{format_counts(line_counts.sum, word_counts.sum, byte_sizes.sum, max_len, options)} total" if ARGV.size > 1
