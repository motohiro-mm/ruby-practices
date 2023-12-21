# frozen_string_literal: true

class Directory
  def initialize(options, path)
    @options = options
    @path = path
  end

  def pick_up_path_names
    pathname = "#{@path}/*"
    path_names = @options['a'] ? Dir.glob(pathname, File::FNM_DOTMATCH).push("#{@path}/..").sort : Dir.glob(pathname).sort
    path_names.reverse! if @options['r']
    path_names
  end
end
