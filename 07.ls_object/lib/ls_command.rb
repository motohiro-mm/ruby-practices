# frozen_string_literal: true

require_relative 'long_formatter'
require_relative 'short_formatter'

class LsCommand
  def initialize(path, options)
    @options = options
    @path = path
  end

  def output(terminal_width)
    formatter(terminal_width).output
  end

  private

  def formatter(terminal_width)
    directory = Directory.new(pick_up_paths)
    @options['l'] ? LongFormatter.new(directory) : ShortFormatter.new(directory, terminal_width)
  end

  def pick_up_paths
    pathname = "#{@path}/*"
    path_names = @options['a'] ? Dir.glob(pathname, File::FNM_DOTMATCH).push("#{@path}/..").sort : Dir.glob(pathname).sort
    path_names.reverse! if @options['r']
    path_names
  end
end
