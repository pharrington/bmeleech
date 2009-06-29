#!/usr/bin/ruby

require 'rubygems'
require 'mechanize'

root = File.join File.dirname(__FILE__), "bms"
agent = WWW::Mechanize.new

styles ={ :empress => :iidx16,
          :troopers => :iidx15,
          :gold => :iidx14,
          :dd => :iidx13,
          :hs => :iidx12,
          :red => :iidx11,
          :cs => :cs,
        }
(1..10).each {|i| styles.merge!({i.to_s => format("iidx%02d", i)}) }

styles.each do |h|
  style = h.first.to_s
  path = h.last.to_s
  base = File.join root, path
  page = agent.get "http://bms.bemaniso.ws/?style=#{style}"
  hrefs = page.links.select { |l| l.attributes["class"] == "info" }.collect &:href
  FileUtils.mkdir_p base
  hrefs.each do |href|
    puts "downloading #{href}"
    bme = agent.get href
    File.open(base + bme.filename.gsub(/^"|"$/, ""), "w") { |f| f.write bme.body }
  end
end
