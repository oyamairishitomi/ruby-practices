# frozen_string_literal: true

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.on('-l') { options[:l] = true }
  opts.on('-w') { options[:w] = true }
  opts.on('-c') { options[:c] = true }
end.parse!(ARGV)

file_counts = []

if ARGV.empty?
  content = $stdin.read
  file_counts << {line: content.lines.count, word: content.split.count, bytes: content.bytesize }
else
  ARGV.each do |file_name|
    content = File.read(file_name)
    file_counts << {line: content.lines.count, word: content.split.count, bytes: content.bytesize }
  end
end

max_len = [file_counts.map { |d| d[:line] } + file_counts.map { |d| d[:word] } + file_counts.map { |d| d[:bytes] }].max.to_s.length

def format_counts(datam, options, max_len)
  line = datam[:line]
  word = datam[:word]
  bytes = datam[:bytes]
  values = []
  values << line.to_s.rjust(max_len) if options[:l] || options.empty?
  values << word.to_s.rjust(max_len) if options[:w] || options.empty?
  values << bytes.to_s.rjust(max_len) if options[:c] || options.empty?
  values.join(' ')
end

if ARGV.empty?
  puts format_counts(file_counts.first, options, max_len)
else
  ARGV.each_with_index do |file_name, i|
    puts "#{format_counts(file_counts[i], options, max_len)} #{file_name}"
  end
end

puts "#{format_counts({ line: file_counts.sum { |d| d[:line] }, word: file_counts.sum { |d| d[:word] }, bytes: file_counts.sum { |d| d[:bytes] } }, options, max_len)} total" if ARGV.size > 1
