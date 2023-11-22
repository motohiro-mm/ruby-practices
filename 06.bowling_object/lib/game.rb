# frozen_string_literal: true

class Game
  def initialize(marks)
    grouped_marks = Game.group_by_frame(marks.split(','))
    @frames = grouped_marks.map { |grouped_mark| Frame.new(grouped_mark) }
  end

  def self.group_by_frame(marks)
    frames = Array.new(10) { [] }
    frames.each.with_index do |frame, i|
      if i == 9
        frame.concat(marks)
      elsif marks[0] == 'X'
        frame.push(marks.shift)
      else
        2.times { frame.push(marks.shift) }
      end
    end
    frames
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
        @frames[i + 1].first_shot.score
      else
        0
      end
    end.sum
  end

  def calculate_strike_bonus(frames, index)
    if index == 8 || !frames[index + 1].strike?
      frames[index + 1].first_shot.score + frames[index + 1].second_shot.score
    else
      10 + frames[index + 2].first_shot.score
    end
  end
end
