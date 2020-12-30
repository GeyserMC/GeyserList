# Cache all servers on boot (asynchronously)

# Class to store Server Info
class ServerInfo
  attr :players, :max_players, :version
  attr_reader :timestamp

  def initialize(online, players, max_players, version)
    @online = online
    @players = players
    @max_players = max_players
    @version = version
    @timestamp = Time.now
  end

  def offline?
    !@online
  end
end

Server.all.each do |server|
  puts "Querying #{server.name}"
  server.query
end