# frozen_string_literal: true

class Frame
  attr_reader :first_shot_score, :second_shot_score, :third_shot_score

  def initialize(shots)
    @first_shot = Shot.new(shots[0])
    @first_shot_score = @first_shot.score
    @second_shot_score = Shot.new(shots[1]).score
    @third_shot_score = Shot.new(shots[2]).score
  end

  def sum_shots_score
    first_shot_score + second_shot_score + third_shot_score
  end

  def strike?
    @first_shot.mark == 'X'
  end

  def spare?
    sum_shots_score == 10 && !strike?
  end
end
