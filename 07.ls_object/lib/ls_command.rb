# frozen_string_literal: true

require_relative 'long_formatter'
require_relative 'short_formatter'

class LsCommand
  def initialize(options, path)
    @formatter = options['l'] ? LongFormatter.new(pick_up_path_names(options, path)) : ShortFormatter.new(pick_up_path_names(options, path))
  end

  def pick_up_path_names(options, path)
    pathname = "#{path}/*"
    path_names = options['a'] ? Dir.glob(pathname, File::FNM_DOTMATCH).push("#{path}/..").sort : Dir.glob(pathname).sort
    path_names.reverse! if options['r']
    path_names
  end

  def ls_print(terminal_width)
    @formatter.output(terminal_width)
  end
end
