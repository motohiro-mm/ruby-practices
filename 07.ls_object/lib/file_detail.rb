# frozen_string_literal: true

require 'date'
require 'etc'

class FileDetail
  attr_reader :name

  def initialize(path)
    @name = File.basename(path)
    @stat = File.stat(path)
  end

  def block
    @stat.blocks
  end

  FILE_TYPE = {
    'file' => '-',
    'directory' => 'd',
    'link' => 'l',
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'socket' => 's'
  }.freeze
  PERMISSION = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'].freeze

  def mode
    FILE_TYPE[@stat.ftype] + [convert_permission(-3, 4, 's') + convert_permission(-2, 2, 's') + convert_permission(-1, 1, 't')].join
  end

  def link
    @stat.nlink.to_s
  end

  def user_name
    Etc.getpwuid(@stat.uid).name
  end

  def group_name
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size.to_s
  end

  def updated_at
    updated_time = @stat.mtime
    if Date.today.prev_month(6).to_time > updated_time
      updated_time.strftime('%_m %_d  %Y')
    else
      updated_time.strftime('%_m %_d %H:%M')
    end
  end

  private

  def convert_permission(number, special_number, special_permission)
    file_permission = @stat.mode.to_s(8).chars
    permission = PERMISSION[file_permission[number].to_i].chars
    permission[2] = special_permission if file_permission[-4] == special_number.to_s
    permission
  end
end
