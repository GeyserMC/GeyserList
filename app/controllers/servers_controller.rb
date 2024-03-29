class ServersController < ApplicationController
  def index
    @servers = Server.all.select("id, name, bedrock_ip").limit(100)
  end

  def show
    @server = Server.find_by(id: params[:id])

    if @server.nil?
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404.html", status: 404, :layout => false }
      end
      return
    end

    @owner = @server.user
    @info = @server.status

    # Get reviews and store data where appropriate
    @reviews = Review.where(server_id: @server.id)
    @profiles = User.where(id: @reviews.map(&:user_id)).pluck(:id, :username)
    ratings = @reviews.map(&:rating)
    @average_rating = ratings.empty? ? nil : ratings.sum.to_f/ratings.count
    @current_review = @reviews.find { |r| r.user_id == @user.id } if @user

    return if @info.offline?

    @version_info = @info.version.split(' ')[1].gsub(/\(|\)/, "")
    @branch = @version_info.split('-')[1...-1].join("-")
    @commit = @version_info.split('-').last
  end

  def new
    unless session[:id]
      session[:page] = request.url
      redirect_to '/login'
      return
    end

    @server = Server.new

    if flash[:server].nil?
      flash[:server] = {}
    end
  end

  def create
    unless params[:server][:discord] == ''
      code = params[:server][:discord].split("discord.gg/").last
      begin
        JSON.parse(RestClient.get("https://discord.com/api/invite/#{code}"))
      rescue RestClient::NotFound, RestClient::TooManyRequests
        flash[:modal_js] = "Invalid Discord Code!"
        flash[:server] = params[:server].to_unsafe_h
        redirect_to '/servers/new'
        return
      end
    end

    bedrock = JSON.parse(RestClient.get("https://api.mcsrvstat.us/2/#{params[:server][:bedrock_ip]}"))
    bedrock_issue = nil
    bedrock_issue = "Bedrock server is offline!" unless bedrock['online']
    bedrock_issue = "No Valid Geyser Found. Make sure you're up to date!" unless bedrock['version'].start_with? "Geyser" if bedrock['online']
    if bedrock_issue
      flash[:modal_js] = bedrock_issue
      flash[:server] = params[:server].to_unsafe_h
      redirect_to '/servers/new'
      return
    end

    java = JSON.parse(RestClient.get("https://api.mcsrvstat.us/2/#{params[:server][:java_ip]}"))
    java_issue = nil
    java_issue = "Java server is offline!" unless java['online']
    if java_issue
      flash[:modal_js] = java_issue
      flash[:server] = params[:server].to_unsafe_h
      redirect_to '/servers/new'
      return
    end

    # TODO: Validate website and site for swears

    server_params = params[:server].to_unsafe_h
    server_params['user_id'] = session[:id]

    server = Server.create(server_params)
    if server.valid?
      redirect_to "/servers/#{server.id}"
    else
      flash[:modal_js] = server.errors.full_messages.join("<br>")
      flash[:server] = params[:server].to_unsafe_h
      redirect_to '/servers/new'
    end
  end

  def requery
    server = Server.find(params['server_id'])

    redirect_to "/servers/#{params['server_id']}"

    if server.nil?
      flash[:modal_js] = "Server doesn't exist. Stop breaking site pls"
      return
    end

    unless session[:id] == server.user_id
      flash[:modal_js] = "You don't own that server. Stop breaking site pls"
      return
    end

    last_queried = server.status.timestamp

    if last_queried > Time.now - 5.minutes
      flash[:modal_js] = "This server was recently queried. Please wait 5 minutes between manual queries!"
      return
    end

    server.query(false)

    flash[:modal_js] = "Successfully re-queried the server!"
  end

  def destroy
    server = Server.find_by(id: params['id'])

    if server.nil?
      flash[:modal_js] = "Server doesn't exist. Stop breaking site pls"
      redirect_to "/servers/#{params['id']}"
      return
    end

    unless session[:id] == server.user_id
      flash[:modal_js] = "You don't own that server. Stop breaking site pls"
      redirect_to "/servers/#{params['id']}"
      return
    end

    server.destroy!

    redirect_to "/"
    flash[:modal_js] = "Server deleted successfully."
  end

  def edit
    @server = Server.find(params[:id])

    if @server.nil?
      flash[:modal_js] = "Server doesn't exist. Stop breaking site pls"
      redirect_to server_path(@server)
      return
    end

    unless session[:id] == @server.user_id
      flash[:modal_js] = "You don't own that server. Stop breaking site pls"
      redirect_to server_path(@server)
    end
  end

  def update
    @server = Server.find(params[:id])
    begin
      @server.update! description: params[:server][:description],
                      website: params[:server][:website],
                      discord: params[:server][:discord]
      flash[:modal_js] = "Updated successfully."
      redirect_to server_path(@server)
    rescue ActiveRecord::RecordInvalid
      flash[:modal_js] = @server.errors.full_messages.join("<br>")
      flash[:server] = params[:server].to_unsafe_h
      redirect_to server_path(@server) + '/edit'
    end
  end

  def result
    ip = params['bedrock_ip'] + ":" + params['bedrock_port']
    unless ip.split(':').length == 2
      ip = "#{ip}:19132"
    end

    QueryServerJob.perform_now ip

    @info = Rails.cache.fetch("status/#{ip}")

    return if @info.offline?

    if @info.version.split(' ').length < 2
      @version_info = "Unknown"
      @branch = "Unknown"
      @commit = "Unknown"
      return
    end

    @version_info = @info.version.split(' ')[1].gsub(/\(|\)/, "")
    @branch = @version_info.split('-')[1...-1].join("-")
    @commit = @version_info.split('-').last
  end
end
