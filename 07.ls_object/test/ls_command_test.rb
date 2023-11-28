# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_command'
require_relative '../lib/file_status'

class LsCommandTest < Minitest::Test
  def test_files
    options = { a: true, l: false, r: false }
    assert_equal ['.', '..', '.gitkeep', 'fizzbuzz.rb'], LsCommand.new('../01.fizzbuzz', options).files

    options2 = { a: false, l: false, r: false }
    assert_equal ['fizzbuzz.rb'], LsCommand.new('../01.fizzbuzz', options2).files
  end
end
