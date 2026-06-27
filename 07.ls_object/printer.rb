# frozen_string_literal: true

require_relative 'entry_list'

class Printer
  MAX_COLUMN_NUMBER = 3

  def print_in_column(entries)
    names = entries.map(&:name)

    item_len_max = names.map(&:length).max
    height = (names.length.to_f / MAX_COLUMN_NUMBER).ceil
    height.times do |row|
      MAX_COLUMN_NUMBER.times do |col|
        item = names[row + col * height]
        print "#{item.to_s.ljust(item_len_max, ' ')} " if item
      end
      puts ''
    end
  end

  def print_in_detail(entry_list, reverse:)
    puts "total #{entry_list.total_blocks}"

    widths = %i[nlink owner group size].to_h { |attr| [attr, entry_list.max_width(attr)] }

    entry_list.sorted_entries(reverse: reverse).each do |entry|
      permission = entry.type_char + entry.permission_string
      nlink = entry.nlink.rjust(widths[:nlink])
      owner = entry.owner.rjust(widths[:owner])
      group = entry.group.rjust(widths[:group])
      size = entry.size.rjust(widths[:size])
      puts "#{permission} #{nlink} #{owner} #{group} #{size} #{entry.mtime} #{entry.name}"
    end
  end
end
