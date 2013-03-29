# example use:
#   rake favicons["../img/origin.png"]
#
# Output:
#   ./apple-touch-icon-114x114-precomposed.png	
#   ./apple-touch-icon-114x114.png
#   ./apple-touch-icon-57x57-precomposed.png		
#   ./apple-touch-icon-57x57.png
#   ./apple-touch-icon-72x72-precomposed.png
#   ./apple-touch-icon-72x72.png
#   ./apple-touch-icon-precomposed.png
#   ./apple-touch-icon.png
#   ./favicon.ico

require "RMagick"

desc "Generates favicons and webapp icons"
task :favicons, :origin do |t, args|
  name = "apple-touch-icon-%dx%d.png"
  name_pre = "apple-touch-icon-%dx%d-precomposed.png"
  
  FileList["*apple-touch-ico*.png"].each do |img|
    File.delete img
  end
  
  FileList["*favicon.ico"].each do |img|
    File.delete img
  end
  
  origin = args.origin || ['./favicon.png']
  FileList[origin].each do |img|
    puts "creating favicon.ico"
    Magick::Image::read(img).first.resize(32, 32).write("favicon.ico")
    
    [114, 57, 72].each do |size|
      puts "creating %d * %d icons" % [size, size]
      Magick::Image::read(img).first.resize(size, size).write(name % [size, size]).write(name_pre % [size, size])
    end
    
    puts "creating backward-compatible icons"
    
    cp name_pre % [57, 57], "apple-touch-icon.png"
    cp name_pre % [57, 57], "apple-touch-icon-precomposed.png"
  end
end