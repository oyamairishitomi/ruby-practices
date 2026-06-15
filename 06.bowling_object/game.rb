# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(score_str)
    @balls = score_str.split(',')
    @shots = @balls.map { |b| Shot.new(b) }

    @frames = []
    i = 0
    9.times do
      if @shots[i].pins == 10
        @frames << Frame.new([@shots[i]])
        i += 1
      else
        @frames << Frame.new(@shots[i, 2])
        i += 2
      end
    end
    @frames << Frame.new(@shots[i..])
  end

  def score
    @frames.each_with_index.sum do |frame, i|
      bonus_shots = @frames[(i + 1)..].flat_map(&:shots)
      frame.score + frame.bonus(bonus_shots)
    end
  end
end

game = Game.new(ARGV[0])
puts game.score
