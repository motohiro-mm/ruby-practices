# frozen_string_literal: true

require_relative 'directory'

class LongFormatter
  def initialize(path_names)
    @files_status = Directory.new(path_names).files_info.map(&:status)
  end

  def output(_)
    max_length_stats = %i[link user_name group_name size].map { |key| max_length_stat(@files_status, key) }
    "total #{sum_block(@files_status)}\n" + format_files_status(@files_status, max_length_stats)
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
end
