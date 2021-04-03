require 'socket'

UDP_RECV_TIMEOUT = 3  # seconds

class QueryServerJob < ApplicationJob
  queue_as :default

  def perform(ip)
    addy = ip.split(':')
    result = q2cmd(addy[0], addy[1], "status")
    Rails.cache.fetch("status/#{ip}", expires_in: 4.hours, force: true) do
      next ServerInfo.new false, nil, nil, nil if result.nil?

      result = result.split("\x00")
      next ServerInfo.new false, nil, nil, nil if result.length < 23

      response = pretty_response result

      ServerInfo.new true, response['numplayers'], response['maxplayers'], response['version']
    end
  end

  def q2cmd(server_addr, server_port, cmd_str)
    resp, sock = nil, nil
    begin
      cmd = "\xFE\xFD\x00\x00\x00\x00\x01\x00\x91\x29\x5B"
      sock = UDPSocket.new
      sock.connect(server_addr, server_port)
      sock.send(cmd, 0x00)
      resp = if select([sock], nil, nil, UDP_RECV_TIMEOUT)
               sock.recvfrom(65535)
             end
      if resp
        resp[0] = resp[0].sub("\x00\x00\x00\x00\x01", "")
        #resp[0] = resp[0][4..-1]  # trim leading 0xffffffff
      end
    rescue IOError, SystemCallError, SocketError, ArgumentError
      # Ignored
    ensure
      sock.close if sock
    end
    resp ? resp[0] : nil
  end

  def pretty_response(response)
    hash = {}
    response.each_with_index do |r, i|
      if i.zero?
        hash["motd"] = r
        next
      end
      next if i == 1
      next if i.even?
      next if i == 23

      hash[response[i-1]] = r
    end

    hash
  end
end
