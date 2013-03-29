require 'rubygems'
require 'less'
require 'rake'
 
 
desc "Compile Less"
task :lessc do
  puts 'Building _style.less...'
  path = File.join( ".", "assets", "themes", "twitter", "css" )
  input = File.join( path, "_style.less" )
  output = File.join( path, "style.css" )
 
  source = File.open( input, "r" ).read
 
  parser = Less::Parser.new( :paths => [path] )
  tree = parser.parse( source )
 
  File.open( output, "w+" ) do |f|
    f.puts tree.to_css( :compress => true )
  end
  puts 'Done'
end # task :lessc