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
    max_lengths_of_links = @directory.max_length_of_stat(@directory.links)
    max_lengths_of_user_names = @directory.max_length_of_stat(@directory.user_names)
    max_lengths_of_group_names = @directory.max_length_of_stat(@directory.group_names)
    max_lengths_of_sizes = @directory.max_length_of_stat(@directory.sizes)

    @directory.files_info.map do |file_info|
      [file_info.mode,
       file_info.link.rjust(max_lengths_of_links + 1),
       file_info.user_name.rjust(max_lengths_of_user_names),
       file_info.group_name.rjust(max_lengths_of_group_names + 1),
       file_info.size.rjust(max_lengths_of_sizes + 1),
       file_info.updated_at,
       file_info.name].join(' ')
    end.join("\n")
  end
end
