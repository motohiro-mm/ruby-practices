# frozen_string_literal: true

require 'optparse'
require_relative 'lib/ls_command'

options = ARGV.getopts('arl')
path = ARGV.empty? ? '.' : ARGV.join
terminal_width = `tput cols`.chomp.to_i

puts LsCommand.new(options, path).ls_print(terminal_width)
