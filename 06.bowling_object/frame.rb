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
    !strike? && @shots.first(2).sum(&:pins) == 10
  end

  def score
    @shots.sum(&:pins)
  end

  def bonus(bonus_shots)
    if strike?
      bonus_shots.first(2).sum(&:pins)
    elsif spare?
      bonus_shots.first(1).sum(&:pins)
    else
      0
    end
  end
end
