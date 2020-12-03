class ApiController < ApplicationController
  include Response

  def get_server
    server = Server.find_by(id: params['id'])

    if server.nil?
      json_response({ error: true, response: 'invalid server id' }, 404)
      return
    end

    json_response(server, 200)
  end
end
