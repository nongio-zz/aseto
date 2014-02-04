#!/usr/bin/env ruby
# .ase parser based on Reader/writer for Adobe Swatch Exchange files in Ruby https://github.com/layervault/ase.rb
# example:
# ./aseparse.rb -i ~/Desktop/colors.ase -f html -o index.html
require 'optparse'
require 'erb'
require 'ase'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: aseparser.rb [options]"
  opts.on('-h', '--exporthelp', 'Help me exporting') { |v| puts "Actually the ase parser does not support LAB mode colors, so you must export the swatches palette in the right format. Create a document on Photoshop and ensure that the color mode is set to RGB then from the swatches panel press save Swatches for Exchange..." }
  opts.on('-i', '--input FILEPATH', 'input file.ase') { |v| options[:i] = v }
  opts.on('-o', '--output FILEPATH', 'output file') { |v| options[:o] = v }
  opts.on('-f', '--format FORMATCODE', 'output file format') { |v| options[:f] = v }
  opts.on('-l', '--list', 'list available formats') {
  	puts "available formats:"
  	Dir.foreach('templates/') do |item|
  		puts " • " + item.sub(".erb", "") if item != "." && item != ".."
	end
  }

end.parse!
options[:f] = "xml" if options[:f].nil?

if(options[:i])
	doc = ASE.from_file(options[:i])
end

if(options[:o])
	template = ERB.new File.new("templates/#{options[:f]}.erb").read
	File.open( options[:o], 'w+') do |file|
		file.write(template.result( binding ) )
	end
end