class AuthController < ApplicationController
  # Apple obviously does not provide CSRF, disable it for this method
  skip_before_action :verify_authenticity_token, :only => [:apple]

  def login

  end

  def discord
    # Encode current URL
    url = request.base_url
    el = URI.encode_www_form_component(url)
    # If there's an error
    unless params['error_description'].blank?
      flash[:modal] = params['error_description']
      redirect_to '/login'
      return
    end

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
      flash[:modal] = "Session token expired. Try logging in again!"
      redirect_to '/login'
      return
    end

    integration = Integration.find_by(kind: 'discord', data: data['id'])
    if integration.nil?
      # Make new account
      session[:registration] = true
      session[:kind] = 'discord'
      session[:data] = data['id']
      respond_to do |format|
        format.html { render 'register' }
      end
      return
    else
      user = integration.user
      token = random_string(25)
      user.access_token = token
      user.save!
      session[:id] = user.id
      session[:token] = token
    end

    redirect_to session[:page] || '/'
  end

  def google
    el = URI.encode_www_form_component(request.base_url)
    if params['code'].nil?
      redirect_to "https://accounts.google.com/o/oauth2/v2/auth?redirect_uri=#{el}/login/google&prompt=consent&response_type=code&client_id=482524144732-7spa5fgljc4tohbi9ohll7cdfiv1t7t3.apps.googleusercontent.com&scope=email&access_type=offline"
      return
    end

    data = {
      "code": params['code'],
      "redirect_uri": "#{request.base_url}/login/google",
      "client_id": '482524144732-7spa5fgljc4tohbi9ohll7cdfiv1t7t3.apps.googleusercontent.com',
      "client_secret": Rails.application.credentials.google,
      "scope": 'email',
      "grant_type": 'authorization_code'
    }

    begin
      google = JSON.parse(RestClient.post("https://www.googleapis.com/oauth2/v4/token?#{data.to_query}", {}, 'content-type': 'application/x-www-form-urlencoded'))
    rescue RestClient::BadRequest => e
      flash[:modal] = "Session token expired. Try logging in again!"
      redirect_to '/login'
      return
    end

    token = "Bearer #{google['access_token']}"

    email_data = JSON.parse(RestClient.get('https://www.googleapis.com/oauth2/v1/userinfo?alt=json', Authorization: token))

    integration = Integration.find_by(kind: 'google', data: email_data['email'])
    if integration.nil?
      # Make new account
      session[:registration] = true
      session[:kind] = 'google'
      session[:data] = email_data['email']
      respond_to do |format|
        format.html { render 'register' }
      end
    else
      user = integration.user
      token = random_string(25)
      user.access_token = token
      user.save!
      session[:id] = user.id
      session[:token] = token

      redirect_to session[:page] || '/'
    end
  end

  def login_apple
    data = {
      client_id: "org.geysermc.servers.signin",
      redirect_uri: request.url,
      response_type: "code id_token",
      scope: "email",
      response_mode: "form_post" # form post is required if email is requested
    }

    redirect_to "https://appleid.apple.com/auth/authorize?" + URI.encode_www_form(data)
  end

  def apple
    data = JSON.parse(Base64.decode64(params['id_token'].split('.')[1]))

    user_id = data['sub']
    valid_jwt_token = params['id_token']

    auth = AppleAuth::UserIdentity.new(user_id, valid_jwt_token).validate!
    email = auth[:email]

    integration = Integration.find_by(kind: 'apple', data: email)
    if integration.nil?
      # Make new account
      session[:registration] = true
      session[:kind] = 'apple'
      session[:data] = email
      respond_to do |format|
        format.html { render 'register' }
      end
    else
      user = integration.user
      token = random_string(25)
      user.access_token = token
      user.save!
      session[:id] = user.id
      session[:token] = token

      redirect_to session[:page] || '/'
    end
  end

  def github
    if params['code'].nil?
      data = {
        client_id: "008045a940df3dee151f",
        redirect_uri: request.url,
        allow_signup: true
      }

      redirect_to "https://github.com/login/oauth/authorize?" + URI.encode_www_form(data)
      return
    end

    data = {
      code: params['code'],
      redirect_uri: request.url,
      client_id: '008045a940df3dee151f',
      client_secret: Rails.application.credentials.github
    }

    github = JSON.parse(RestClient.post("https://github.com/login/oauth/access_token",
                                        data,
                                        'content-type': 'application/x-www-form-urlencoded',
                                        Accept: :json
    ))

    token = "token #{github['access_token']}"

    user_data = JSON.parse(RestClient.get('https://api.github.com/user', Authorization: token))

    integration = Integration.find_by(kind: 'github', data: user_data['id'])
    if integration.nil?
      # Make new account
      session[:registration] = true
      session[:kind] = 'github'
      session[:data] = user_data['id']
      respond_to do |format|
        format.html { render 'register' }
      end
    else
      user = integration.user
      token = random_string(25)
      user.access_token = token
      user.save!
      session[:id] = user.id
      session[:token] = token

      redirect_to session[:page] || '/'
    end
  end

  def xbox
    # Encode current URL
    url = url_for(:only_path => false, :overwrite_params=>nil)
    el = URI.encode_www_form_component(url)

    # If there's an error
    if !params['error'].blank?
      flash[:error] = params['error_description']
      redirect_to '/login'
      return
    end

    # Set the client id, secret and scopes
    id = 'ca260d22-3665-436b-ba68-c9c29070213c'
    secret = Rails.application.credentials.xbox
    scopes = ["Xboxlive.signin"]

    # If there's no code parameter
    if params['code'].nil?
      redirect_to "https://login.live.com/oauth20_authorize.srf?client_id=#{id}&response_type=code&approval_prompt=auto&scope=#{scopes.join("+")}&redirect_uri=#{el}"
      return
    end

    # Build the data to send to xbox
    data = {
      grant_type: "authorization_code",
      code: params['code'],
      scope: scopes.join(' '),
      redirect_uri: url,
      client_id: id,
      client_secret: secret
    }

    # Get the access token
    access_token = JSON.parse(RestClient.post("https://login.live.com/oauth20_token.srf",
                                        data,
                                        'content-type': 'application/x-www-form-urlencoded',
                                        Accept: :json
    ))

    data = {
      RelyingParty: "http://auth.xboxlive.com",
      TokenType: "JWT",
      Properties: {
          AuthMethod: "RPS",
          SiteName: "user.auth.xboxlive.com",
          RpsTicket: "d=#{access_token['access_token']}"
      },
    }

    # Get the user token
    user_token = JSON.parse(RestClient.post("https://user.auth.xboxlive.com/user/authenticate",
                                        data.to_json,
                                        'x-xbl-contract-version': '1',
                                        content_type: :json,
                                        Accept: :json
    ))

    data = {
      RelyingParty: "http://xboxlive.com",
      TokenType: "JWT",
      Properties: {
          UserTokens: [user_token['Token']],
          SandboxId: "RETAIL",
      },
    }

    # Get the final xsts token
    xsts_token = JSON.parse(RestClient.post("https://xsts.auth.xboxlive.com/xsts/authorize",
                                        data.to_json,
                                        'x-xbl-contract-version': '1',
                                        content_type: :json,
                                        Accept: :json
    ))

    # Get the final xuid
    user_xuid = xsts_token['DisplayClaims']['xui'][0]['xid'].to_i

    integration = Integration.find_by(kind: 'xbox', data: user_xuid)
    if integration.nil?
      # Make new account
      session[:registration] = true
      session[:kind] = 'xbox'
      session[:data] = user_xuid
      respond_to do |format|
        format.html { render 'register' }
      end
    else
      user = integration.user
      token = random_string(25)
      user.access_token = token
      user.save!
      session[:id] = user.id
      session[:token] = token

      redirect_to session[:page] || '/'
    end
  rescue RestClient::Exception => e
    if e.response.body.blank?
      flash[:error] = "An error #{e.response.code} occured while trying to log you in. Try logging in again!"
    else
      flash[:error] = JSON.parse(e.response.body)['error_description']
    end
    redirect_to '/login'
  end

  def register
    unless session[:registration]
      redirect_to '/login'
      flash[:modal] = "You aren't registering."
      return
    end

    user = User.find_by(username: params['username'])

    if params['username'] == ''
      flash[:modal] = 'This username contains literally nothing! Try again!'
    elsif !user.nil?
      flash[:modal] = 'This username is in use!'
    elsif params['username'].include?(' ')
      flash[:modal] = 'Usernames cannot contain spaces!'
    elsif params['username'].to_i.to_s == params['username'].to_s
      flash[:modal] = 'Usernames cannot be only numbers!'
    elsif params['username'].gsub(/[^0-9A-Za-z._]/, '') != params['username']
      flash[:modal] = 'Usernames can only contain alphanumeric, period and underscore characters.'
    elsif params['username'].length > 32
      flash[:modal] = 'Usernames cannot be longer than 32 characters in length!'
    end

    if flash[:modal]
      redirect_to '/login'
      return
    end

    User.create(username: params['username'], access_token: random_string(25))
    user = User.find_by(username: params['username'])
    Integration.create(user: user, kind: session[:kind], data: session[:data])
    reset_session

    session[:id] = user.id
    session[:token] = user.access_token

    redirect_to '/'
  end

  def logout
    reset_session

    redirect_to "/"
  end
end
