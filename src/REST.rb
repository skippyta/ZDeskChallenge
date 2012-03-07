require 'faraday'

#Set up Faraday connection. Authenticated via primary agent
conn = Faraday::Connection.new(:url => 'https://skippyta%40berkeley.edu:foobar@skippyta.zendesk.com', :ssl => {:verify => false}) do |builder|
  builder.request :url_encoded
  builder.response :logger
  builder.adapter :net_http
end

client_name = "Josh Joiner"
client_email = "josh@usc.edu"
ticket_description = "Exhibit A"

#Post to tickets.xml using agent credentials for given user
#Creates user if not already existing
resp = conn.post do |req|
  req.url '/api/v1/tickets.xml'
  req.body = {:ticket => {:description => ticket_description, :requester_name => client_name,:requester_email => client_email} }
end

#Extract the ticket location in the response
ticket_url = resp.headers["location"]
i = (ticket_url =~ /tickets/) - 1
ticket_url = ticket_url[i, ticket_url.length]

#PUT to /tickets/#{ticketnumber}.xml, updates status_id to 3 (solved)
conn.put do |req|
  req.url '/api/v1' + ticket_url
  req.body = {:ticket => {:status_id => "3"}}
end
