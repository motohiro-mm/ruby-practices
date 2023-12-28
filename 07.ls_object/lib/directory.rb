# frozen_string_literal: true

require_relative 'file_detail'

class Directory
  attr_reader :file_details

  def initialize(paths)
    @file_details = paths.map { |path| FileDetail.new(path) }
  end

  def names
    @file_details.map(&:name)
  end

  def sum_blocks
    @file_details.map(&:block).sum
  end

  def max_lengths(keys)
    maximum_lengths = keys.map do |key|
      send(key).map(&:length).max
    end
    keys.zip(maximum_lengths).to_h
  end

  private

  def links
    @file_details.map(&:link)
  end

  def user_names
    @file_details.map(&:user_name)
  end

  def group_names
    @file_details.map(&:group_name)
  end

  def sizes
    @file_details.map(&:size)
  end
end
