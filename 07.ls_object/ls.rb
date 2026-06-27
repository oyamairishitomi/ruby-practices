# frozen_string_literal: true

require_relative 'entry_list'
require_relative 'options'
require_relative 'printer'

options = Options.new(ARGV)
path = ARGV[0] || '.'

list = EntryList.new(path, show_hidden: options.a?)
printer = Printer.new

if options.l?
  printer.print_in_detail(list, reverse: options.r?)
else
  printer.print_in_column(list.sorted_entries(reverse: options.r?))
end
