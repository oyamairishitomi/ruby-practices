# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(score_str)
    @balls = score_str.split(',').map { |b| b == 'X' ? 10 : b.to_i }
    @shots = @balls.map { |b| Shot.new(b) }

    @frames = []
    i = 0
    9.times do
      if @shots[i].pins == 10
        @frames << Frame.new([@shots[i]])
        i += 1
      else
        @frames << Frame.new([@shots[i], @shots[i + 1]])
        i += 2
      end
    end
    @frames << Frame.new(@shots[i..])
  end

  def score
    total = 0
    @frames.each_with_index do |frame, i|
      total += frame.score
      total += bonus(frame, i)
    end
    total
  end

  private

  def bonus(frame, index)
    if frame.strike? && index < 9
      bonus_shots = @frames[(index + 1)..].flat_map(&:shots)
      bonus_shots[0].pins + bonus_shots[1].pins
    elsif frame.spare? && index < 9
      bonus_shots = @frames[(index + 1)..].flat_map(&:shots)
      bonus_shots[0].pins
    else
      0
    end
  end
end

game = Game.new(ARGV[0])
puts game.score
