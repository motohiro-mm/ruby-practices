# frozen_string_literal: true

class FileStatus
  attr_reader :name, :stat

  def initialize(path)
    @name = File.basename(path)
    @stat = File.lstat(path)
  end
end
