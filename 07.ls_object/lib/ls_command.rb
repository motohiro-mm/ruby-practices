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

  def ls_files(terminal_width)
    @options[:l] ? ls_with_l_option : ls_without_l_option(terminal_width)
  end

  def ls_with_l_option
  end

  def ls_without_l_option(terminal_width)
    filename_width = file_width(files)
    transposed_files = transpose_files(terminal_width)
    transposed_files.map! do |transposed_file|
      transposed_file.map! do |file|
        if file == transposed_file[-1]
          file.ljust(filename_width, ' ') + "\n"
        else
          file.ljust(filename_width, ' ')
        end
      end.join
    end.join.chomp
  end

  def transpose_files(terminal_width)
    files_count = @files.count
    files_column(@files, terminal_width)
    lines = (files_count.to_f / files_column(@files, terminal_width)).ceil
    separated_files = @files.each_slice(lines).to_a
    separated_files[0].zip(*separated_files[1..-1]).map(&:compact)
  end

  def file_width(files)
    filename_lengths = files.map(&:length)
    (filename_lengths.max.to_f/8).ceil*8
  end

  MAX_COLUMN = 3
  def files_column(files, terminal_width)
    filename_width = file_width(files)
    if filename_width * MAX_COLUMN > terminal_width
      filename_width >= terminal_width ? 1 : terminal_width / filename_width
    else
      MAX_COLUMN
    end
  end
end
