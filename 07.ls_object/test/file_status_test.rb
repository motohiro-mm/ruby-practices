# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/file_status'

class FileStatusTest < Minitest::Test
  def setup
    @fizzbuzz = FileStatus.new('../01.fizzbuzz')
    @gitignore = FileStatus.new('../.gitignore')
  end

  def test_file_name
    assert_equal '01.fizzbuzz', @fizzbuzz.name
    assert_equal '.gitignore', @gitignore.name
  end

  def test_file_stat
    assert_instance_of File::Stat, @fizzbuzz.stat
  end

  def test_hidden_file?
    assert @gitignore.hidden_file?
    refute @fizzbuzz.hidden_file?
  end
end
