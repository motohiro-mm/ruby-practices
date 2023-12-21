# frozen_string_literal: true

require_relative 'file_info'

class FormatLong
  def initialize(path_names)
    @files_info = path_names.map { |path_name| FileInfo.new(path_name).status }
  end

  def output(_)
    max_length_stats = %i[link user_name group_name size].map { |key| max_length_stat(@files_info, key) }
    "total #{sum_block(@files_info)}\n" + format_files_status(@files_info, max_length_stats)
  end

  def max_length_stat(files_info, key)
    key_lengths = files_info.map { |file_info| file_info[key].length }
    key_lengths.max
  end

  def sum_block(files_info)
    files_info.map { |file_info| file_info[:block] }.sum
  end

  def format_files_status(files_info, max_length_stats)
    files_info.map do |file_info|
      [file_info[:mode],
       file_info[:link].rjust(max_length_stats[0] + 1),
       file_info[:user_name].rjust(max_length_stats[1]),
       file_info[:group_name].rjust(max_length_stats[2] + 1),
       file_info[:size].rjust(max_length_stats[3] + 1),
       file_info[:update_time],
       file_info[:name]].join(' ')
    end.join("\n")
  end
end
