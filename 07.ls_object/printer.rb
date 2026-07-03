# frozen_string_literal: true

class Printer
  MAX_COLUMN_NUMBER = 3

  def print_in_column(sorted_entries)
    names = sorted_entries.map(&:name)

    item_len_max = names.map(&:length).max
    height = (names.length.to_f / MAX_COLUMN_NUMBER).ceil
    height.times do |row|
      MAX_COLUMN_NUMBER.times do |col|
        item = names[row + col * height]
        print "#{item.ljust(item_len_max)} " if item
      end
      puts
    end
  end

  def max_width(entries, field)
    entries.map { |entry| entry.public_send(field).to_s.length }.max
  end

  def total_blocks(total_entries)
    # 512バイト単位の値を1024バイト単位に変換するため、1024/512=2で割る
    total_entries.sum(&:blocks) / 2
  end

  def print_in_detail(sorted_entries)
    puts "total #{total_blocks(sorted_entries)}"

    widths = %i[nlink owner group size].to_h { |field| [field, max_width(sorted_entries, field)] }

    sorted_entries.each do |sorted_entry|
      permission = sorted_entry.type_char + sorted_entry.permission_string
      nlink = sorted_entry.nlink.to_s.rjust(widths[:nlink])
      owner = sorted_entry.owner.rjust(widths[:owner])
      group = sorted_entry.group.rjust(widths[:group])
      size = sorted_entry.size.to_s.rjust(widths[:size])
      puts "#{permission} #{nlink} #{owner} #{group} #{size} #{sorted_entry.mtime.strftime('%b %e %H:%M')} #{sorted_entry.name}"
    end
  end
end
