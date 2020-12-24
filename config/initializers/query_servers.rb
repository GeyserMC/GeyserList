# Cache all servers on boot (asynchronously)

# Class to store Server Info
class ServerInfo
  attr :players, :max_players, :version
  attr_reader :timestamp

  def initialize(players, max_players, version)
    @players = players
    @max_players = max_players
    @version = version
    @timestamp = Time.now
  end
end

Server.all.each do |server|
  puts "Querying #{server.name}"
  server.query
end