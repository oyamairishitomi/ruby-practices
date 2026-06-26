# frozen_string_literal: true

require 'etc'

class Entry
  PERMISSION_TABLE = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'].freeze

  def initialize(path)
    @path = path
    @stat = File.stat(@path)
  end

  def name
    File.basename(@path)
  end

  def type_char
    case @stat.ftype
    when 'directory' then 'd'
    when 'link' then 'l'
    else '-'
    end
  end

  def permission_string
    digits = @stat.mode.to_s(8)[-3..]
    digits.each_char.map { |char| PERMISSION_TABLE[char.to_i] }.join
  end

  def nlink
    @stat.nlink.to_s
  end

  def owner
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size.to_s
  end

  def mtime
    @stat.mtime.strftime('%b %e %H:%M')
  end

  def blocks
    @stat.blocks
  end
end
