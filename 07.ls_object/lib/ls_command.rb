# frozen_string_literal: true

require_relative 'directory'
require_relative 'format_long'
require_relative 'format_short'

class LsCommand
  def initialize(options, path)
    path_name = Directory.new(options, path).pick_up_path_names
    @directory_with_format = options['l'] ? FormatLong.new(path_name) : FormatShort.new(path_name)
  end

  def ls_print(terminal_width)
    @directory_with_format.output(terminal_width)
  end
end
