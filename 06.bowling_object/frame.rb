# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def strike?
    @shots[0].pins == 10
  end

  def spare?
    !strike? && @shots[0].pins + @shots[1].pins == 10
  end

  def score
    @shots.sum(&:pins)
  end
end
