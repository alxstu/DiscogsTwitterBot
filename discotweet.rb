#!/usr/bin/ruby
require 'rubygems'
require 'oauth'
require 'json'
require "open-uri"


file1 = File.open("/AccessToken.txt")
accessToken = file1.read

file2 = File.open("/AccessTokenSecret.txt")
accessTokenSecret = file2.read

file3 = File.open("/ConsumerKey.txt")
consumerKey = file3.read

file4 = File.open("/ConsumerSecret.txt")
consumerSecret = file4.read



consumer_key = OAuth::Consumer.new(consumerKey, consumerSecret)
access_token = OAuth::Token.new(accessToken, accessTokenSecret)


for x in (1..1000000) do
	begin
		doc = JSON.parse(open("https://api.discogs.com/releases/" + x.to_s ).read)
		
		
		title = doc["title"]
		if title.nil?
		title = "-"
		end

		released = doc["released"]
		if released.nil? || released == 0
		released = "-"
		end
		
		country = doc["country"]
		if country.nil?
		country = "-"
		end
		
		styles = doc["styles"]
				if styles.nil?
		styles = "-"
		else 
		styles = doc["styles"].join(", ")
		end
		
		

		part1 = "\n" + title[0..31] + "\n" + "released: " + released[0..3]  + "\n" + "country: " + country[0..11] + "\n" + "genre: " + styles[0..24] + "\n"

		url = doc["uri"]

		
		tweet = part1.downcase + url + "\n" + "nr.: " + x.to_s
	

		baseurl = "https://api.twitter.com"
		path    = "/1.1/statuses/update.json"
		address = URI("#{baseurl}#{path}")
		request = Net::HTTP::Post.new address.request_uri
		request.set_form_data(
			"status" => tweet,
		)

		# Set up HTTP.
		http             = Net::HTTP.new address.host, address.port
		http.use_ssl     = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		# Issue the request.
		request.oauth! http, consumer_key, access_token
		http.start
		response = http.request request

		# Parse and print the Tweet if the response code was 200
		tweet = nil
		if response.code == '200' then
			tweet = JSON.parse(response.body)
			puts "Successfully sent #{tweet["text"]}"
			sleep 100
		else
			puts "Could not send the Tweet! " +
			"Code:#{response.code} Body:#{response.body}"
		end
		
		rescue Timeout::Error
			puts "The request for a page at timed out...skipping."
			next
		rescue OpenURI::HTTPError => error
		tweet = "no release \nnr: " + x.to_s
		
		
		baseurl = "https://api.twitter.com"
		path    = "/1.1/statuses/update.json"
		address = URI("#{baseurl}#{path}")
		request = Net::HTTP::Post.new address.request_uri
		request.set_form_data(
			"status" => tweet,
		)

		# Set up HTTP.
		http             = Net::HTTP.new address.host, address.port
		http.use_ssl     = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		# Issue the request.
		request.oauth! http, consumer_key, access_token
		http.start
		response = http.request request

		# Parse and print the Tweet if the response code was 200
		tweet = nil
		if response.code == '200' then
			tweet = JSON.parse(response.body)
			puts "Successfully sent #{tweet["text"]}"
			sleep 100
		else
			puts "Could not send the Tweet! " +
			"Code:#{response.code} Body:#{response.body}"
		end

	end	
end
puts "#######loop ended########"
