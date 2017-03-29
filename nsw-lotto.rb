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

  def high_adjacent_check(numbers)
    hashmap = numbers
    for i in (0..numbers.length-1) 
      puts "test number: #{numbers[i]}" if @debug
      count = 0
      adj_numbers = (numbers[i]+1..numbers[i]+3).to_a
      puts "adj numbers: #{adj_numbers}" if @debug
      adj_numbers.each do |a|
        puts "adj test number: #{a}" if @debug
        if hashmap.include?(a)
          count += 1
        end
      end
      puts "count: #{count}" if @debug
      puts "hashmap: #{hashmap}" if @debug
      if count > 2
        puts "high check return true" if @debug
        return true
      end
    end
    puts "hight check return false" if @debug
    return false
  end

  def low_adjacent_check(numbers)
    hashmap = numbers
    for i in (0..numbers.length-1)
      puts "test number: #{numbers[i]}" if @debug
      count = 0
      adj_numbers = (numbers[i]-3..numbers[i]-1).to_a
      puts "adj numbers: #{adj_numbers}" if @debug
      adj_numbers.each do |a|
        if hashmap.include?(a)
          count += 1
        end
      end
      puts "count: #{count}" if @debug
      puts "hashmap: #{hashmap}" if @debug
      if count > 2
        puts "low check return true" if @debug
        return true
      end
    end
    puts "low check return false" if @debug
    return false
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
    main_result = pool_main.sample(draw_main)
    sleep rand(1..5)
    sup_result =  pool_sup.sample(draw_sup) if !pool_sup.empty?
    sleep rand(1..5)
    main_inc_sup = main_result.include?(sup_result[0]) if sup_result
    puts "main: #{main_result}" if @debug
    puts "sup: #{sup_result}" if @debug
    if main_inc_sup
      puts "main numbers include sup numbers, re-roll" if @debug
      draw_numbers
    elsif high_adjacent_check(main_result) or low_adjacent_check(main_result)
      puts "high and low adjacent check failed, re-roll" if @debug
      draw_numbers
    else
      puts "drawed main numbers are: #{main_result.sort}, drawed sup numbers are: #{sup_result.sort if sup_result}\n\n"
      %x(echo "drawed main numbers are: #{main_result.sort}, drawed sup numbers are: #{sup_result.sort if sup_result}" >> lotto-result.txt) if !@debug
      %x(echo "\r" >> lotto-result.txt) if !@debug
    end
  end

  def gettickets
    %x(date >> lotto-result.txt) if !@debug
    pool_sort
    (1..@game).each { sleep rand(1..5);  draw_numbers; sleep rand(1..5)  }
  end
end


draw = LottoDraw.new
draw.parse_command_line(ARGV)
results = draw.gettickets

