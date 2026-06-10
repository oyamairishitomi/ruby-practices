#!/usr/bin/env ruby
# frozen_string_literal: true

balls = ARGV[0].split(',').map { |b| b == 'X' ? 10 : b.to_i }

frame_starts = (1..9).each_with_object([0]) do |_, frame_indices|
  i = frame_indices.last
  next_start = i + (balls[i] == 10 ? 1 : 2)
  frame_indices << next_start
end

score = frame_starts.first(9).sum do |i|
  if balls[i] == 10 || balls[i] + balls[i + 1] == 10
    balls[i, 3].sum
  else
    balls[i] + balls[i + 1]
  end
end
score += balls[frame_starts.last..].sum

puts score
