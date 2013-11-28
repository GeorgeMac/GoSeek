require 'octokit'

client = Octokit::Client.new :login => 'Username', :password => 'Password'

namespace :ghub do
	task :legacy_seed, [:count] => :environment do |t, args|
		args.with_defaults(:count => 10)
		count = Float(args[:count])
		count = 1000 unless count <= 1000
		if count <= 100 
			client.legacy_search_repositories("language:go").each { |e| ghubToEntry(e) }
		else
			pages = (count / 100).ceil
			pages.times do |i|
				if i == pages - 1
					items = client.legacy_search_repositories("language:go", start_page: i+1).slice(0,count - (i * 100))
				else
				    items = client.legacy_search_repositories("language:go", start_page: i+1)
				end
				items.each{ |e| ghubToEntry(e) }
			end
		end
	end
end

def ghubToEntry(e)
	Entry.new({
			title: e.name,
			url: "http://github.com/#{e.username}/#{e.name}",
			description: e.description,
			forks: e.forks,
			stars: e.watchers
		}).save
end
