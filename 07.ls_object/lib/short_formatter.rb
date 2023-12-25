# frozen_string_literal: true

require_relative 'directory'

class ShortFormatter
  def initialize(path_names)
    @files_name = Directory.new(path_names).files_info.map(&:name)
  end

  def output(terminal_width)
    filename_width = file_width(@files_name)
    transposed_files = transpose_files(terminal_width)
    transposed_files.map! do |transposed_file|
      transposed_file.map! do |file|
        if file == transposed_file[-1]
          "#{file}\n"
        else
          file.ljust(filename_width, ' ')
        end
      end.join
    end.join.chomp
  end

  def transpose_files(terminal_width)
    files_count = @files_name.count
    lines = (files_count.to_f / files_column(@files_name, terminal_width)).ceil
    separated_files = @files_name.each_slice(lines).to_a
    separated_files[0].zip(*separated_files[1..]).map(&:compact)
  end

  def file_width(files)
    filename_length_max = files.map(&:length).max
    filename_length_max += 1 if (filename_length_max % 8).zero?
    (filename_length_max.to_f / 8).ceil * 8
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
