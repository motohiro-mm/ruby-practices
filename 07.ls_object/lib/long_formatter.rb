# frozen_string_literal: true

require_relative 'directory'

class LongFormatter
  def initialize(directory)
    @directory = directory
  end

  def output(_)
    "total #{@directory.sum_blocks}\n" + format_file_details
  end

  private

  def format_file_details
    keys = %i[links user_names group_names sizes]
    max_lengths = @directory.max_lengths(keys)

    @directory.file_details.map do |file_detail|
      [file_detail.mode,
       file_detail.link.rjust(max_lengths[:links] + 1),
       file_detail.user_name.rjust(max_lengths[:user_names]),
       file_detail.group_name.rjust(max_lengths[:group_names] + 1),
       file_detail.size.rjust(max_lengths[:sizes] + 1),
       file_detail.updated_at,
       file_detail.name].join(' ')
    end.join("\n")
  end
end
