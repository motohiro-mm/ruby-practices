# frozen_string_literal: true

require_relative 'file_info'

class Directory
  attr_reader :files_info

  def initialize(paths)
    @files_info = paths.map { |path| FileInfo.new(path) }
  end

  def names
    @files_info.map(&:name)
  end

  def sum_blocks
    @files_info.map(&:block).sum
  end

  def max_length_of_stat(files_status)
    files_status.map(&:length).max
  end

  def links
    @files_info.map(&:link)
  end

  def user_names
    @files_info.map(&:user_name)
  end

  def group_names
    @files_info.map(&:group_name)
  end

  def sizes
    @files_info.map(&:size)
  end
end
