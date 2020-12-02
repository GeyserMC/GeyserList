class ServersController < ApplicationController
  def index
    @servers = Server.all.limit(100)
  end

  def show
    @server = Server.find_by(id: params[:id])
    
    if @server.nil?
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404.html", status: 404, :layout => false }
      end
    end
  end
end
