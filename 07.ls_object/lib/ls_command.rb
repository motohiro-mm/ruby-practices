# frozen_string_literal: true

class LsCommand
  attr_reader :files

  def initialize(path, options)
    @options = options
    @files = get_files_with_a_or_r_option(path)
  end

  def get_files_with_a_or_r_option(path)
    files = @options[:a] ? Dir.foreach(path).to_a.sort : Dir.glob('*', base: path).sort
    files.reverse! if @options[:r]
    files
  end
end
