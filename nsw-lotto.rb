#!/usr/bin/ruby
#-*- coding: UTF-8 -*-

#######################################
####    This script can be used    ####
####    for OZ LOTTO or PowerBall  ####
####    written by: Jason Shen     ####
#######################################


# Game Guide
# Power Ball:           6 in 40 pluse 1 in 20
# OZ Lotto:             7 in 45 
# Monday Lotto:         6 in 45
# Wensday Lotto:        6 in 45
# Saturday Lotto:       6 in 45
# The Pools:            6 in 38


require 'optparse'

class LottoDraw

  def initialize
    @game = 1
    @playtype = 0
    @debug = false
    @pool_main = []
    @pool_sup = []
    @draw_main = 0
    @draw_sup = 0
  end

  def parse_command_line(args)

    opt_parser = OptionParser.new do |opts|

      opts.on("-g", "--game number", "ticket number") do |game|
        @game = game.to_i
      end

      opts.on("-t", "--type number", "game type, 1:powerball, 2: ozlotto, else:monday/wednesday/saturday lotto" ) do |type|
        @playtype = type.to_i
      end

      opts.on("-d", "--debug", "debug mode") do |debug|
        @debug = true
      end
    end
    opt_parser.parse(args)
  end

  def adjacent_check(numbers)
    result = numbers.inject([]) { |l, e| (!l==[]&&l[-1][-1]+1==e)?l[0..-2]+[l[-1]+[e]]:l+[[e]]}
    puts result if @debug
    if result.inject{|memo, array| memo.length>array.length ? memo : array}.length>=4
      puts result
      return false
    else
      return true
    end
  end

  def pool_sort
    case @playtype
    when 1 then @pool_main = (1..40).to_a;@pool_sup = (1..20).to_a;@draw_main = 6;@draw_sup = 1;puts "This is powerball lotto"; %x(echo "This is powerball lotto" >> lotto-result.txt) if !@debug
    when 2 then @pool_main = (1..45).to_a;@draw_main = 7;@draw_sup = 0; puts "This is OZLotto"; %x(echo "This is OZLotto" >> lotto-result.txt) if !@debug
    else @pool_main = (1..45).to_a;@draw_main = 6; @draw_sup = 0; puts "This is Monday/Wednesday/Saturday Lotto"; %x(echo "This is Monday/Wednesday/Saturday Lotto" >> lotto-result.txt) if !@debug end
  end

  def draw_numbers
    pool_main = @pool_main
    pool_sup = @pool_sup
    puts "main pool: #{pool_main}" if @debug
    puts "sup pool: #{pool_sup}" if @debug
    draw_main = @draw_main
    draw_sup = @draw_sup
    main_result = pool_main.sample(draw_main).sort
    sleep rand(1..5)
    sup_result =  pool_sup.sample(draw_sup).sort if !pool_sup.empty?
    sleep rand(1..5)
    main_inc_sup = main_result.include?(sup_result[0]) if sup_result
    puts "main: #{main_result}" if @debug
    puts "sup: #{sup_result}" if @debug
    puts "re-roll" if main_inc_sup and @debug
    if main_inc_sup
      draw_numbers
    else    
      puts "drawed main numbers are: #{main_result}, drawed sup numbers are: #{sup_result if sup_result}\n\n"
      %x(echo "drawed main numbers are: #{main_result}, drawed sup numbers are: #{sup_result if sup_result}" >> lotto-result.txt) if !@debug
      %x(echo "\r" >> lotto-result.txt) if !@debug
    end
  end

  def gettickets
    %x(date >> lotto-result.txt) if !@debug
    pool_sort
    (1..@game).each { sleep rand(1..5); draw_numbers; sleep rand(1..5) }
  end
end


draw = LottoDraw.new
draw.parse_command_line(ARGV)
results = draw.gettickets

