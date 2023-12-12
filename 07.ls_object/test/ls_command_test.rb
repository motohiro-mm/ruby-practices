# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_command'
require_relative '../lib/file_info'

class LsCommandTest < Minitest::Test
  def setup
    options = {'a'=>false, 'l'=>false, 'r'=>false}
    @ls_command = LsCommand.new(options, '..')

    l_option = {'a'=>false, 'l'=>true, 'r'=>false}
    @ls_command_with_l = LsCommand.new(l_option, '..')
    @ls_command_06bowling_with_l = LsCommand.new(l_option, '../06.bowling_object')
  end

  def test_ls_command_files
    a_option = {'a'=>true, 'l'=>false, 'r'=>false}
    assert_equal ['.', '..', '.gitkeep', 'fizzbuzz.rb'], LsCommand.new(a_option, '../01.fizzbuzz').file_names

    a_r_options = {'a'=>true, 'l'=>false, 'r'=>true}
    assert_equal ['fizzbuzz.rb', '.gitkeep', '..', '.'], LsCommand.new(a_r_options, '../01.fizzbuzz').file_names
  end

  def test_ls_files_without_l_terminal_width_86
    example = <<~TEXT.chomp
    01.fizzbuzz             05.wc                   99.wc_object            
    02.calendar             06.bowling_object       README.md               
    03.bowling              07.ls_object            
    04.ls                   98.rake                 
    TEXT
    assert_equal example, @ls_command.ls_files(86)
  end

  def test_ls_files_without_l_terminal_width_71
    example = <<~TEXT.chomp
    01.fizzbuzz             06.bowling_object       
    02.calendar             07.ls_object            
    03.bowling              98.rake                 
    04.ls                   99.wc_object            
    05.wc                   README.md               
    TEXT
    assert_equal example, @ls_command.ls_files(71)
  end

  def test_ls_files_without_l_terminal_width_47
    example = <<~TEXT.chomp
    01.fizzbuzz             
    02.calendar             
    03.bowling              
    04.ls                   
    05.wc                   
    06.bowling_object       
    07.ls_object            
    98.rake                 
    99.wc_object            
    README.md               
    TEXT
    assert_equal example, @ls_command.ls_files(47)
  end

  def test_ls_files_with_l
    example = <<~TEXT.chomp
    total 8
    drwxr-xr-x  4 omisan  staff   128  3 28  2023 01.fizzbuzz
    drwxr-xr-x  4 omisan  staff   128  3 28  2023 02.calendar
    drwxr-xr-x  4 omisan  staff   128 11 28 10:57 03.bowling
    drwxr-xr-x  4 omisan  staff   128  3 28  2023 04.ls
    drwxr-xr-x  4 omisan  staff   128  3 28  2023 05.wc
    drwxr-xr-x  7 omisan  staff   224 11 28 10:57 06.bowling_object
    drwxr-xr-x  6 omisan  staff   192 11 28 16:36 07.ls_object
    drwxr-xr-x  3 omisan  staff    96  3 28  2023 98.rake
    drwxr-xr-x  3 omisan  staff    96  3 28  2023 99.wc_object
    -rw-r--r--  1 omisan  staff  2648  3 28  2023 README.md
    TEXT
    assert_equal example, @ls_command_with_l.ls_files(86)
  end

  def test_ls_files_06bowling_with_l
    example = <<~TEXT.chomp
    total 8
    -rw-r--r--  1 omisan  staff  166 11 28 10:57 bowling.rb
    drwxr-xr-x  5 omisan  staff  160 11 28 10:57 lib
    drwxr-xr-x  5 omisan  staff  160 11 28 10:57 test
    TEXT
    assert_equal example, @ls_command_06bowling_with_l.ls_files(86)
  end
end
