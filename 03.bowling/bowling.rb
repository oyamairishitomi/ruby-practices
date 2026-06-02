#!/usr/bin/env ruby
# frozen_string_literal: true

balls = ARGV[0].split(',').map { |b| b == 'X' ? 10 : b.to_i }

score = 0
i = 0

9.times do
  if balls[i] == 10
    score += 10 + balls[i + 1] + balls[i + 2]
    i += 1
  elsif balls[i] + balls[i + 1] == 10
    score += 10 + balls[i + 2]
    i += 2
  else
    score += balls[i] + balls[i + 1]
    i += 2
  end
end

score += balls[i..].sum

puts score
