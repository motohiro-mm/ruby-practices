# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls_command'
require_relative '../lib/file_status'

class LsCommandTest < Minitest::Test
  def setup
    options = { a: false, l: false, r: false }
    @ls_command = LsCommand.new('..', options)
  end

  def test_ls_command_files
    a_option = { a: true, l: false, r: false }
    assert_equal ['.', '..', '.gitkeep', 'fizzbuzz.rb'], LsCommand.new('../01.fizzbuzz', a_option).files

    a_r_options = { a: true, l: false, r: true }
    assert_equal ['fizzbuzz.rb', '.gitkeep', '..', '.'], LsCommand.new('../01.fizzbuzz', a_r_options).files
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
end
