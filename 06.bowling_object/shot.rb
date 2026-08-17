# frozen_string_literal: true

class Shot
  attr_reader :pins

  def initialize(mark)
    @pins = mark == 'X' ? 10 : mark.to_i
  end
end
