#!/usr/bin/ruby
#-*- coding: UTF-8 -*-

#######################################
####    This script can be used    ####
####    for OZ LOTTO or PowerBall  ####
####    written by: Jason Shen     ####
#######################################


# Game Guide
#
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
    @playtype = [0]
    @debug = false
  end

  def parse_command_line(args)

    opt_parser = OptionParser.new do |opts|

      opts.on("-g", "--game number", "ticket number") do |game|
        @game = game.to_i
      end

      opts.on("-t", "--type number", "game type, 1:powerball, 2:monday/wednsday/saturday lotto, any number: ozlotto(default lotto)") do |type|
        @playtype[0] = type.to_i
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

  def powerball
  # power ball: main number -> six balls, powerball number -> 1 number
  # power ball may have awkward result, like this real draw result: 
  # 25,36,30,9,34,40, p: 11
  # 19,26,9,29,27,6,  p: 15
  # 20,29,1,16,15,26, p: 12
  # so, our splitted arry of numbers is quite interesting
  # every time, pick up two from the array
  # generate a number pool, rand pick number from the pool
    target_number = 6
    main_draw_number = []
    origin_draw_range = [[1, 10], [11, 19], [20, 29], [30, 40]]
    weight = 0
    while target_number - weight > 0
      puts "origin draw range: #{origin_draw_range}" if @debug
      number = 6
      while number == 6
        number = rand(1..(target_number - weight))
      end
      puts "number: #{number}" if @debug
      picked_range = origin_draw_range.sample(1)
      puts "picked range: #{picked_range}" if @debug
      rand_number = []
      until rand_number != [] and rand_number.length == rand_number.uniq.length
       rand_number += Array.new(number) { rand(picked_range[-1][0]..picked_range[-1][-1]) } 
      end
      puts "rand number: #{rand_number}" if @debug
      main_draw_number += rand_number
      puts "main draw number: #{main_draw_number}" if @debug
      weight += number
      puts "weight: #{weight}" if @debug
      origin_draw_range -= picked_range
    end
    puts "main number: #{main_draw_number}"
  end



  def satlotto
    draw_range = [[1, 23], [24, 45]]
    main_number = 6
  end

  def ozlotto
  # oz lotto: first draw the six balls in (1..15), (16..29), (30..45), two numbers in each range,
  # the draw last number in one range again selected by dice
    draw_range = [[1, 15], [16, 29], [30, 45]]
  end

  def gettickets
    powerball
  end  
end


draw = LottoDraw.new
draw.parse_command_line(ARGV)
results = draw.gettickets

