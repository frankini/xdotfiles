#!/usr/bin/env ruby

$stdout.sync = true

colors = { :red => "#843026",
           :yellow => "#FFCB00",
           :blue => "#586875" }


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
    print "%{l} %{F#{colors[:yellow]}}%{F-} "
    print "%{c} " 
    s.each do |t|
      print "%{F#{colors[:red]}}" if t[:focus]
      print " " if t[:state] == :occupied
      print " " if t[:state] == :free
      print "%{F-} "
    end

    print "%{r}"
    if (monitor == 0)
      print "%{F#{colors[:red]}}%{F-} %#{song}" unless song.empty?
      print " %{F#{colors[:red]}}%{F-} #{memfree} %{F#{colors[:red]}}%{F-} #{time} "
    end
    monitor += 1
  end
  print "\n"
end
