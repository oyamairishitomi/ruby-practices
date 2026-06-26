# frozen_string_literal: true

require 'optparse'

class Options
  def initialize(argv)
    @options = argv.getopts('arl')
  end

  def a?
    @options['a']
  end

  def r?
    @options['r']
  end

  def l?
    @options['l']
  end
end
