dirs = [
	'./favicon.*',
	'./apple-touch*.png',
	'./*.ico',
	'./assets/img/logo/*'
]

desc "Replace image colors"
task :imgcolor do
	from = ENV["from"] || 'rgb(0,0,0)'
	to = ENV["to"] || 'rgb(51,51,51)'
	fuzz = ENV["fuzz"] || '10%'

	puts "Replacing #{from} #{fuzz} to #{to}..."
	for dir in dirs
		for filename in Dir[dir]
			puts "  #{filename}"
			cmd = "convert #{filename} -fuzz #{fuzz} -fill '#{to}' -opaque '#{from}' #{filename}"
			#puts "    `#{cmd}`"
			`#{cmd}`
		end
	end
	puts 'Done'
end

