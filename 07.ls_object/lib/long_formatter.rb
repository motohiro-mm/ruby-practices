# frozen_string_literal: true

require_relative 'directory'

class LongFormatter
  def initialize(directory)
    @directory = directory
  end

  def output(_)
    "total #{@directory.sum_blocks}\n" + format_files_info
  end

  def format_files_info
    keys = %i[links user_names group_names sizes]
    max_lengths = @directory.max_lengths(keys)

    @directory.files_info.map do |file_info|
      [file_info.mode,
       file_info.link.rjust(max_lengths[:links] + 1),
       file_info.user_name.rjust(max_lengths[:user_names]),
       file_info.group_name.rjust(max_lengths[:group_names] + 1),
       file_info.size.rjust(max_lengths[:sizes] + 1),
       file_info.updated_at,
       file_info.name].join(' ')
    end.join("\n")
  end
end
