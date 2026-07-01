# frozen_string_literal: true

require 'optparse'

def format_counts(counts, options, max_len)
  line = counts[:line]
  word = counts[:word]
  bytes = counts[:bytes]
  values = []
  values << line.to_s.rjust(max_len) if options[:l] || options.empty?
  values << word.to_s.rjust(max_len) if options[:w] || options.empty?
  values << bytes.to_s.rjust(max_len) if options[:c] || options.empty?
  values.join(' ')
end

options = {}
OptionParser.new do |opts|
  opts.on('-l') { options[:l] = true }
  opts.on('-w') { options[:w] = true }
  opts.on('-c') { options[:c] = true }
end.parse!(ARGV)
sources = ARGV.empty? ? [nil] : ARGV
file_counts = []

sources.each do |file_name|
  content = file_name.nil? ? $stdin.read : File.read(file_name)
  file_counts << { line: content.lines.count, word: content.split.count, bytes: content.bytesize }
end

total_counts = file_counts.each_with_object({ line: 0, word: 0, bytes: 0 }) do |d, sum|
  sum[:line]  += d[:line]
  sum[:word]  += d[:word]
  sum[:bytes] += d[:bytes]
end

max_len = (total_counts.values + file_counts.flat_map(&:values)).max.to_s.length

sources.each_with_index do |file_name, i|
  puts [format_counts(file_counts[i], options, max_len), file_name].compact.join(' ')
end

puts "#{format_counts(total_counts, options, max_len)} total" if sources.size > 1
