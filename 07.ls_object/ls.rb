# frozen_string_literal: true

require 'optparse'
require_relative 'lib/ls_command'

options = ARGV.getopts('arl')
path = ARGV.empty? ? '.' : ARGV.join
terminal_width = `tput cols`.chomp.to_i

puts LsCommand.new(path, options).output(terminal_width)
