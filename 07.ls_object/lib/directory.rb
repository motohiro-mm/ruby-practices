# frozen_string_literal: true

require_relative 'file_info'

class Directory
  attr_reader :files_info

  def initialize(path_names)
    @files_info = path_names.map { |path_name| FileInfo.new(path_name) }
  end
end
