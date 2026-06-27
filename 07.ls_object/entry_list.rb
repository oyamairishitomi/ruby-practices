# frozen_string_literal: true

require_relative 'entry'

class EntryList
  def initialize(dir_path, show_hidden: false)
    @dir_path = dir_path
    file_names = Dir.entries(dir_path)
    file_names = file_names.reject { |file| file.start_with?('.') } unless show_hidden
    @entries = file_names.map { |name| Entry.new(File.join(dir_path, name)) }
  end

  def sorted_entries(reverse: false)
    sorted = @entries.sort_by(&:name)
    reverse ? sorted.reverse : sorted
  end

  def total_blocks
    # 512バイト単位の値を1024バイト単位に変換するため、1024/512=2で割る
    @entries.sum(&:blocks) / 2
  end

  def max_width(attr)
    @entries.map { |entry| entry.public_send(attr).length }.max
  end
end
