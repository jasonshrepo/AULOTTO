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

  def powerball
  # power ball: main number -> six balls, powerball number -> 1 number
  # power ball may have awkward result, like this real draw result: 
  # 25,36,30,9,34,40, p: 11
  # 19,26,9,29,27,6,  p: 15
  # 20,29,1,16,15,26, p: 12
  # so, our splitted arry of numbers is quite interesting
  # every time, pick up two from the array
  # generate a number pool, rand pick number from the pool
    main_number = 6 
    origin_draw_range = [[1, 15], [16, 29], [30, 45]]
    picked_draw_range = origin_draw_range.sample(2)
    puts "picked draw range: #{picked_draw_range}" if @debug
    weight = rand(1..5)
    puts "weight: #{weight}" if @debug   
    rand_draw_range = picked_draw_range.sample(1).flatten
    puts "rand draw range: #{rand_draw_range}" if @debug
    powerball_main_number = []
    powerball_main_number += (rand_draw_range[0]..rand_draw_range[1]).to_a.sample(weight)
    puts "powerball main number: #{powerball_main_number}" if @debug
    rest_weight = main_number - weight
    puts "rest_weight: #{rest_weight}" if @debug
    rest_draw_range = picked_draw_range.flatten - rand_draw_range
    puts "rest_draw_range: #{rest_draw_range}" if @debug
    rest_draw_range.sort!
    puts "rest_draw_range: #{rest_draw_range}" if @debug
    powerball_main_number += (rest_draw_range[0]..rest_draw_range[1]).to_a.sample(rest_weight)
    puts "powerball_main_number: #{powerball_main_number}" if @debug
    powerball_pb_number = ((1..20).to_a - powerball_main_number).sample(1)
    puts "powerball main number: #{powerball_main_number.sort}, powerball number: #{powerball_pb_number}"
    return "powerball main number: #{powerball_main_number.sort}, powerball number: #{powerball_pb_number}"
  end



  def satlotto
  # sat lotto: main number -> six balls
  # draw six balls in (1..23), (24..45), three numbers in each range.
    draw_range = [[1, 23], [24, 45]]
    main_number = 6
    weight = rand(1..5)
    sample_draw_range = draw_range.sample(1).flatten
    lotto_number = []
    lotto_number += (sample_draw_range[0]..sample_draw_range[1]).to_a.sample(weight)
    puts "lotto_number: #{lotto_number}" if @debug
    rest_weight = main_number - weight
    rest_draw_range = (draw_range.flatten - sample_draw_range).sort
    puts "rest_draw_range: #{rest_draw_range}" if @debug
    lotto_number += (rest_draw_range[0]..rest_draw_range[1]).to_a.sample(rest_weight)
    puts "saturday lotto main number: #{lotto_number.sort}"
    return  "saturday lotto main number: #{lotto_number.sort}"
  end

  def ozlotto
  # oz lotto: first draw the six balls in (1..15), (16..29), (30..45), two numbers in each range,
  # the draw last number in one range again selected by dice
    draw_range = [[1, 15], [16, 29], [30, 45]]
    main_number = 6
    lotto_number = []
    draw_range.each do |x|
      lotto_number += (x[0]..x[1]).to_a.sample(2).sort
    end
    puts "oz lotto main number: #{lotto_number}" if @debug
    lotto_number += ((1..45).to_a - lotto_number).sample(1)
    puts "oz lotto main number: #{lotto_number.sort}"
    return "oz lotto main number: #{lotto_number.sort}"
  end

  def gettickets
    result = []
    if @playtype.include?(1)
      puts "This is a Power Ball draw"
      i = 1
      until i > @game
        i += 1
        result += [powerball]
      end
    elsif @playtype.include?(2)
      puts "This is a Saturday Lotto draw"
      i = 1
      until i > @game
        i += 1
        result += [satlotto]
      end
    else
      puts "This is a OZ Lotto draw"
      i = 1
      until i > @game
        i += 1
        result += [ozlotto]
      end
    end
    puts "result: #{result}" if @debug
    %x(date >> lotto-result.txt)
    result.each do |x|
      %x(echo #{x} >> lotto-result.txt)
    end
    %x(echo "\r" >> lotto-result.txt)
  end
end


draw = LottoDraw.new
draw.parse_command_line(ARGV)
results = draw.gettickets

