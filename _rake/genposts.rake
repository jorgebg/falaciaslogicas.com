require 'liquid'
require 'slugify'

template = Liquid::Template.parse(
"{{ metadata }}
---
{{ content }}"
)

default = {
	'layout' => 'post'
}

desc "Generate posts described in _posts.yml"
task :genposts do
	config = YAML::load_file '_config.yml'
	posts = YAML::load_file '_posts.yml'
	post_filenames = []

	puts "Updating #{posts.length} posts..."
	for post in posts
		post = default.clone.merge!(post)
		post['slug'] ||= post['title'].slugify
		post['description'] ||= post['tagline']
		post['keywords'] ||= post['title'].downcase
		post['keywords'] = post['keywords'] + ', ' + config['title'].downcase
		post['title'] = post['title']
		post.delete 'category' # TODO
		
		data = post.clone
		content = data.delete 'content'
		metadata = YAML::dump data
		rendered = template.render(
			'metadata' => metadata,
			'content' => content
		)

		filename = File.join(
			CONFIG['posts'],
			Time.now.strftime('%Y-%m-%d') + '-' + post['slug'] + '.md'
		)

		create = true
		for old_filename in Dir[File.join(
			CONFIG['posts'],
			'*-' + post['slug'] + '.md'
		)]
			if File.exist? old_filename
				if File.read(old_filename) != rendered and (
					(ENV['ask'] and ask(
						'"' + post['slug'] + '"' +
						" has changed. Do you want to recreate it?",
						['y', 'n']
					) == 'y') or not ENV['ask']
				)
					File::delete old_filename
					puts old_filename + ' deleted'
				else
					create = false
					post_filenames << old_filename
					puts old_filename + ' ignored'
					next
				end
			end
		end

		if create
			file = File.new(filename, "w")
			file.write rendered
			file.close
			post_filenames << filename
			puts filename + ' created'
		end
	end

	puts 'Cleaning...'
	for filename in Dir[File.join(
			CONFIG['posts'], '*.md'
		)]
		if not post_filenames.include? filename
			File::delete filename
			puts filename + ' deleted'
		end
	end

	puts 'Done'
end

