#!/usr/bin/env ruby

$stdout.sync = true

colors = { :fg  => "#FFFFFF",
           :dim => "#C7C7C7" }


monitors = []
clock = ""
time = ""
song = ""
memfree = ""
title = ""
am = 0

ARGF.each do |line|
  
  line.chomp!

  if line.start_with?("S")
    sysinfoitems = line[1..-1].split("|")

    sysinfoitems.each do |item|
      if item.start_with?("r")
        memfree = item[1..-1]
      elsif item.start_with?("m")
        song = item[1..-1]
      elsif item.start_with?("t")
        time = item[1..-1]
      end
    end
  elsif line.start_with?("T")
    title = line[1..-1]
  elsif line.start_with?("W")
    items = line[1..-1].split(":")

    monitor = 0
    desktop = 0

    items.each do |item|
      if item.start_with?('M', 'm')
        monitor = item[1..-1].to_i - 1
        am = monitor if item[0] == 'M'
        monitors[monitor] = []
      elsif item.start_with?("O")
        monitors[monitor].push({ :state => :occupied, :focus => true })
      elsif item.start_with?("F")
        monitors[monitor].push({:state => :free, :focus => true })
      elsif item.start_with?("U")
        monitors[monitor].push({ :state => :urgent, :focus => true })
      elsif item.start_with?("o")
        monitors[monitor].push({ :state => :occupied, :focus => false })
      elsif item.start_with?("f")
        monitors[monitor].push({ :state => :free, :foucs => false })
      elsif item.start_with?("u")     
        monitors[monitor].push({ :state => :occupied, :focus => false })
      end
    end
  end
  monitor = 0
  monitors.each do |s|
    print "%{S#{monitor}}"
    print "%{l} "
    s.each do |t|
      print "%{F#{colors[:fg]}}"  if t[:state] == :occupied
      print "%{F#{colors[:dim]}}" if t[:state] == :free
      if (t[:focus])
        print "O"
      else
        print "o"
      end
    end
    print "%{c}#{title}" if monitor == am
    print " %{r} %#{song}  #{memfree}  #{time} " if monitor == 0
    monitor += 1
  end
  print "\n"
end

