# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/file_info'

class FileStatusTest < Minitest::Test
  def setup
    @fizzbuzz = FileInfo.new('../01.fizzbuzz')
    @gitignore = FileInfo.new('../.gitignore')
  end

  def test_file_name
    assert_equal '01.fizzbuzz', @fizzbuzz.name
    assert_equal '.gitignore', @gitignore.name
  end

  def test_file_stat
    assert_instance_of File::Stat, @fizzbuzz.stat
  end

  def test_file_status
    fizzbuzz_status = { block: 0,
                        mode: 'drwxr-xr-x',
                        link: '4',
                        user_name: 'omisan',
                        group_name: 'staff',
                        size: '128',
                        update_time: ' 3 28  2023',
                        name: '01.fizzbuzz' }
    assert_equal fizzbuzz_status, @fizzbuzz.status

    gitignore_status = { block: 8,
                         mode: '-rw-r--r--',
                         link: '1',
                         user_name: 'omisan',
                         group_name: 'staff',
                         size: '2099',
                         update_time: '12 11 13:02',
                         name: '.gitignore' }
    assert_equal gitignore_status, @gitignore.status
  end
end
