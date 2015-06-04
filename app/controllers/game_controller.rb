require 'erb'
require 'json'
require 'codebreaker'

class GameController

  JSON_HEADER = {'Content-Type' => 'application/json'}

  def call(env)
    @request = Rack::Request.new(env)
    @game = @request.session[:game]
    @request_body = JSON.parse(@request.body.read,symbolize_names: true) if @request.post?

    case @request.path
      when '/'
        render_template('index.html.erb')
      when '/game'
        render_json @game ? @game.to_hash : nil
      when '/new_game'
        render_json new_game(@request_body[:user_name])
      when '/destroy_game'
        render_json destroy_game
      when '/guess'
        render_json @game.guess(@request_body[:user_code]).to_hash
      when '/hint'
        @game.hint
        render_json @game.to_hash
      when '/cheat'
        render_json @game.secret_code.join
      when '/scores'
        scores = Codebreaker::Game.load
        scores.map! { |score| score.to_hash }
        render_json scores
      when '/save'
        @game.save
        @request.session[:game] = nil
        render_json true
      else
        Rack::Response.new('Not Found', 404)
    end
  end

  private
  def render(data)
    Rack::Response.new(data)
  end

  def render_template(template)
    path = File.expand_path("app/views/#{template}")
    result = ERB.new(File.read(path)).result(binding)
    render(result)
  end

  def render_json(data)
    Rack::Response.new(data.to_json, 200, JSON_HEADER)
  end

  def new_game(user_name)
    user = Codebreaker::User.new user_name
    @game = @request.session[:game] = Codebreaker::Game.new user
    @game.to_hash
  end

  def destroy_game
    @game = @request.session[:game] = nil
  end
end