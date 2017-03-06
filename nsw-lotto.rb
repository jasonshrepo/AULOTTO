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

      opts.on("-t", "--type number", "game type") do |type|
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
  # first draw the six balls in (1..15), (16..29), (30..45), two numbers in each range,
  # then draw powerball number in (1..20)
    origin_draw_range = [[1, 15], [16, 29], [30, 45]]
  # get range weight
    range_weight = rand(2..3)
    if range_weight == 2
      draw_range = []
      draw_range = origin_draw_range.sample(range_weight)
    powerball_range = [1, 20]
    main_number = 6
    each_range_round_for_main = 2
    drawed_numbers = []
    draw_range.each do |range|
      low = range[0]
      high = range[1]
      i = 1
      until i > each_range_round_for_main
        number = rand(low..high)
        if !drawed_numbers.include?(number)
          drawed_numbers += [number]
          i += 1
        end
      end
    end
    drawed_numbers.sort! { |x, y| x <=> y }
    j = 2
    while j > 1
      low = powerball_range[0]
      high = powerball_range[1]
      powerball_number = rand(low..high)
      if !drawed_numbers.include?(powerball_number)
        drawed_numbers += ["powerball number : #{powerball_number}"]
        j = 0
      end
    end
    return drawed_numbers
  end

  def satlotto
  # sat lotto: main number -> six balls
  # draw six balls in (1..23), (24..45), three numbers in each range.
    draw_range = [[1, 23], [24, 45]]
    main_number = 6
    each_range_round_for_main = 3
    drawed_numbers = []
    draw_range.each do |range|
      low = range[0]
      high = range[1]
      i = 1
      until i > each_range_round_for_main
        number = rand(low..high)
        if !drawed_numbers.include?(number)
          drawed_numbers += [number]
          i += 1
        end
      end
    end
    drawed_numbers.sort! { |x, y| x <=> y }
    return drawed_numbers
  end

  def ozlotto
  # oz lotto: first draw the six balls in (1..15), (16..29), (30..45), two numbers in each range,
  # the draw last number in one range again selected by dice
    draw_range = [[1, 15], [16, 29], [30, 45]]
    main_number = 6
    each_range_round_for_main = 2
    drawed_numbers = []
    draw_range.each do |range|
      low = range[0]
      high = range[1]
      i = 1
      until i > each_range_round_for_main
        number = rand(low..high)
        if !drawed_numbers.include?(number)
          drawed_numbers += [number]
          i += 1
        end
      end
    end
    j = 2
    while j > 1
      seventh_number = rand(1..45)
      if !drawed_numbers.include?(seventh_number)
        drawed_numbers += [seventh_number]
        j = 0
      end
    end
    drawed_numbers.sort! { |x, y| x <=> y }
    return drawed_numbers
  end

  def gettickets
    drawresult = []
    if @playtype.include?(1)
      puts "This is a Power Ball draw"
      i = 1
      until i > @game
        i += 1
        drawresult += [powerball]
      end
    elsif @playtype.include?(2)
      puts "This is a Saturday Lotto draw"
      i = 1
      until i > @game
        i += 1
        drawresult += [satlotto]
      end
    else
      puts "This is a OZ Lotto draw"
      i = 1
      until i > @game
        i += 1
        drawresult += [ozlotto]
      end
    end
    return drawresult
  end

end


draw = LottoDraw.new
draw.parse_command_line(ARGV)
results = draw.gettickets
results.each do |result|
  puts "one game is picked as :#{result}\n"
end
