# frozen_string_literal: true

require_relative 'format_long'
require_relative 'format_short'

class LsCommand
  def initialize(options, path)
    @directory_with_format = options['l'] ? FormatLong.new(pick_up_path_names(options, path)) : FormatShort.new(pick_up_path_names(options, path))
  end

  def pick_up_path_names(options, path)
    pathname = "#{path}/*"
    path_names = options['a'] ? Dir.glob(pathname, File::FNM_DOTMATCH).push("#{path}/..").sort : Dir.glob(pathname).sort
    path_names.reverse! if options['r']
    path_names
  end

  def ls_print(terminal_width)
    @directory_with_format.output(terminal_width)
  end
end
