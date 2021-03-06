#!/usr/bin/env ruby

require 'fiber'

inp = $stdin.read
initial_program = inp.split(",").map{ |x| x.to_i }

class Memory < Array
  def [](a)
    v = super(a)
    v || 0
  end
end

class VM
  attr_reader :input

  def in_param
    a = @program[@pc]
    @pc += 1
    # 0 = position mode
    # 1 = immediate mode
    # 2 = relative mode
    if @instruction % 10 == 0
      a = @program[a]
    elsif @instruction % 10 == 2
      a = @program[@rb+a]
    end
    @instruction /= 10
    a
  end

  def out_param
    a = @program[@pc]
    @pc += 1
    if @instruction % 10 == 2
      a += @rb
    end
    @instruction /= 10
    a
  end

  def read_int
    #puts "reading input"
    @input.shift
  end

  def initialize(program, input)
    @program = Memory.new(program.clone)
    @input = input
    @output = []
    @pc = 0
    @rb = 0 # relative base
    @instruction = 0
  end

  def halted
    @program[@pc] == 99
  end

  def run
    fiber = Fiber.new do
      #puts "running " + @program[@pc].to_s
      while not halted do
        @instruction = out_param
        op = @instruction % 100
        #puts "PC #{@pc.to_s} RB #{@rb} INSTRUCTION #{@instruction} OP #{op.to_s}"
        @instruction /= 100

        case op
        when 1 # add
          ap = in_param
          bp = in_param
          c = out_param
          @program[c] = ap + bp
        when 2 # mul
          ap = in_param
          bp = in_param
          c = out_param
          @program[c] = ap * bp
        when 3 # input
          a = out_param
          @program[a] = read_int
        when 4 # output
          ap = in_param
          @input.push(Fiber.yield ap)
        when 5 # jit
          ap = in_param
          bp = in_param
          if ap != 0
            @pc = bp
          end
        when 6 # jif
          ap = in_param
          bp = in_param
          if ap == 0
            @pc = bp
          end
        when 7 # lt
          ap = in_param
          bp = in_param
          c = out_param
          @program[c] = ap < bp ? 1 : 0
        when 8 # eq
          ap = in_param
          bp = in_param
          c = out_param
          @program[c] = ap == bp ? 1 : 0
        when 9 # rb adjust
          ap = in_param
          @rb += ap
        else
          puts 'bad bad'
          puts 'pc ' + @pc.to_s
          puts 'in ' + @program[@pc].to_s
          puts 'op ' + op.to_s
          puts @program.to_s
          break
        end
      end
      false
    end
    fiber
  end
end

puts "part A"
vm = VM.new(initial_program, [1]).run
while (a = vm.resume) do
  puts a
end
puts "part B"
vm = VM.new(initial_program, [2]).run
while (a = vm.resume) do
  puts a
end
