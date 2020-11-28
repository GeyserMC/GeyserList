class AuthController < ApplicationController
  def login

  end

  def discord
    # Encode current URL
    url = request.base_url
    el = URI.encode_www_form_component(url)
    # If there's no code parameter
    if params['code'].nil?
      redirect_to "https://discord.com/api/oauth2/authorize?client_id=781715071134072832&redirect_uri=#{el}%2Flogin/discord&response_type=code&scope=identify"
      return
    end

    code = params['code']

    # Discord OAuth Nonsense
    uri = URI.parse('https://discord.com/api/v6/oauth2/token')
    discord = Net::HTTP::Post.new(uri)
    discord.content_type = 'application/x-www-form-urlencoded'
    discord.set_form_data(
      'client_id' => '781715071134072832',
      'client_secret' => Rails.application.credentials.discord,
      'grant_type' => 'authorization_code',
      'code' => code,
      'redirect_uri' => "#{url}/login/discord",
      'scope' => 'identify'
    )

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(discord)
    end
    # response.code

    # Get Discord Details
    bob = JSON.parse(response.body)
    begin
      data = JSON.parse(RestClient.get('https://discord.com/api/v6/users/@me', Authorization: "Bearer #{bob['access_token']}"))
    rescue RestClient::Unauthorized
      flash[:invalid] = "Session token expired. Try logging in again!"
      redirect_to '/login'
      return
    end

    integration = Integration.find_by(kind: 'discord', data: data['id'])
    if integration.nil?
      # Make new account
      session[:registration] = true
      session[:kind] = 'discord'
      session[:data] = data['id']
      return
    else
      user = User.find_by(id: integration.userid)
      token = random_string(25)
      user.access_token = token
      user.save!
      session[:id] = user.id
      session[:token] = token
    end

    redirect_to session[:page] || '/'
  end

  def register
    unless session[:registration]
      redirect_to '/login'
      flash[:bruh] = "You aren't registering."
      return
    end

    if params['username'] == ''
      flash[:cause_profile] = 'This username contains literally nothing! Try again!'
    elsif params['username'].include?(' ')
      flash[:cause_profile] = 'This username contains a space!'
    elsif params['username'].to_i.to_s == params['username'].to_s
      flash[:cause_profile] = 'This username contains only numbers!'
    elsif params['username'].gsub(/[^0-9A-Za-z._]/, '') != params['username']
      flash[:cause_profile] = 'This username contains special characters!'
    elsif params['username'].length > 32
      flash[:cause_profile] = 'This username is too long!'
    end

    if flash[:cause_profile]
      redirect_to '/login'
      return
    end

    User.create(username: params['username'], access_token: random_string(25))
    user = User.find_by(username: params['username'])
    Integration.create(userid: user.id, kind: session[:kind], data: session[:data])
    reset_session

    session[:id] = user.id
    session[:token] = user.access_token

    redirect_to '/'
  end
end
