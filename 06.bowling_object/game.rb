# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(score_str)
    @balls = score_str.split(',')
    @shots = @balls.map { |b| Shot.new(b) }

    i = 0
    @frames = 9.times.map do
      count = if @shots[i].pins == 10 then 1 else 2 end
      frame = Frame.new(@shots[i, count])
      i += count
      frame
    end
    @frames << Frame.new(@shots[i..])
  end

  def score
    @frames.each_with_index.sum do |frame, i|
      bonus_shots = @frames[(i + 1)..].flat_map(&:shots).first(2)
      frame.score + frame.bonus(bonus_shots)
    end
  end
end

game = Game.new(ARGV[0])
puts game.score
