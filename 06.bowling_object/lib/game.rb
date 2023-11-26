# frozen_string_literal: true

class Game
  def initialize(marks)
    grouped_marks = Game.group_by_frame(marks.split(','))
    @frames = grouped_marks.map { |grouped_mark| Frame.new(grouped_mark) }
  end

  def self.group_by_frame(marks)
    10.times.map do |i|
      if i == 9
        marks
      elsif marks[0] == 'X'
        [marks.shift]
      else
        marks.shift(2)
      end
    end
  end

  def total_score
    sum_frames_score + sum_bonus_score
  end

  def sum_frames_score
    @frames.map(&:sum_shots_score).sum
  end

  def sum_bonus_score
    @frames.map.with_index do |frame, i|
      if i == 9
        0
      elsif frame.strike?
        calculate_strike_bonus(@frames, i)
      elsif frame.spare?
        @frames[i + 1].first_shot_score
      else
        0
      end
    end.sum
  end

  def calculate_strike_bonus(frames, index)
    if index == 8 || !frames[index + 1].strike?
      frames[index + 1].first_shot_score + frames[index + 1].second_shot_score
    else
      10 + frames[index + 2].first_shot_score
    end
  end
end
