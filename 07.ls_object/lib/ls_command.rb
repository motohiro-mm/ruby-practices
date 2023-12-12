# frozen_string_literal: true

require_relative 'file_info'

class LsCommand
  attr_reader :file_names

  def initialize(options, path)
    @options = options
    @path_names = get_path_names_with_a_or_r_option(path)
    @file_names = @path_names.map { |path_name| File.basename(path_name) }
  end

  def get_path_names_with_a_or_r_option(path)
    pathname = "#{path}/*"
    path_names = @options['a'] ? Dir.glob(pathname, File::FNM_DOTMATCH).push("#{path}/..").sort : Dir.glob(pathname).sort
    path_names.reverse! if @options['r']
    path_names
  end

  def ls_files(terminal_width)
    @options['l'] ? ls_with_l_option : ls_without_l_option(terminal_width)
  end

  def ls_with_l_option
    files_status = @path_names.map { |path_name| FileInfo.new(path_name).status }
    max_length_stats = %i[link user_name group_name size].map { |key| max_length_stat(files_status, key) }
    "total #{sum_block(files_status)}\n" + format_files_status(files_status, max_length_stats)
  end

  def max_length_stat(files_status, key)
    key_lengths = files_status.map { |file_status| file_status[key].length }
    key_lengths.max
  end

  def sum_block(files_status)
    files_status.map { |file_status| file_status[:block] }.sum
  end

  def format_files_status(files_status, max_length_stats)
    files_status.map do |file_status|
      [file_status[:mode],
       file_status[:link].rjust(max_length_stats[0] + 1),
       file_status[:user_name].rjust(max_length_stats[1]),
       file_status[:group_name].rjust(max_length_stats[2] + 1),
       file_status[:size].rjust(max_length_stats[3] + 1),
       file_status[:update_time],
       file_status[:name]].join(' ')
    end.join("\n")
  end

  def ls_without_l_option(terminal_width)
    filename_width = file_width(@file_names)
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
    files_count = @file_names.count
    lines = (files_count.to_f / files_column(@file_names, terminal_width)).ceil
    separated_files = @file_names.each_slice(lines).to_a
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
