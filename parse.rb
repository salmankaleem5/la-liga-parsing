require 'rubygems'
require 'nokogiri'
require 'json'
require 'open-uri'

def savePageLocally()
	File.open('laliga.html', 'w') do |file|
		open("https://en.wikipedia.org/wiki/2017%E2%80%9318_La_Liga") do |uri|
			file.write(uri.read)
		end
	end
end

# Save web pagepage locally so you can parse locally. Prevents frequent requests to web page.
if File.exist?("laliga.html") == false
	puts "saving page locally"
	savePageLocally()
end

# Load page and parse to get all clubs in La Liga

doc = Nokogiri::HTML(File.open('laliga.html'))

#=begin
resultsTableNode = doc.at_css('h3 span#Results').parent().next_element()

rows = resultsTableNode.css('tr')

# teamNameAbbr maps Full Name to Abbreviation
# Ex: "FC Barcelona" to "BAR"
firstRowNode = rows.first().css("th a")
teamNameAbbr = {}
firstRowNode.each{ |node| teamNameAbbr[node['title']] = node.text }


# teamNameNiceName maps Full Name to Nice Name
# Ex: "FC Barcelona" to "Barcelona" 
teamNameNiceName = {}
rows[1, rows.size].each do |row|
	a_tag = row.first_element_child.first_element_child
	teamNameNiceName[a_tag['title']] = a_tag.inner_html()
end

# teamsHash maps Nice Name to Full Name and Abbreviation
teamNames = {}
teamNameAbbr.each{ |key, value| teamNames[teamNameNiceName[key]] = { "full_name" => key, "abbr" => value } }

File.open('teams.json', "w") do |f|
	f.write(JSON.pretty_generate(teamNames))
end
#=end