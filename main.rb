require 'sinatra'
require 'warden'
require 'rack-flash'
require_relative 'models/init'
require_relative 'routes'

use Rack::Session::Cookie, secret: "IdoNoHaveAnySecret"
use Rack::Flash, accessorize: [:error, :success]

use Warden::Manager do |config|
  # serialize user to session ->
  config.serialize_into_session{|user| user.id}
  # serialize user from session ->
  config.serialize_from_session{|id| User.get(id)}
  # configuring strategies
  config.scope_defaults :default,
              strategies: [:password],
              action: 'auth/unauthenticated'
  config.failure_app = self
end

Warden::Strategies.add(:password) do
  def flash
    env['x-rack.flash']
  end

  def valid?
    params['user'] && params['user']['username'] && params['user']['password']
  end

  def authenticate!
    # find for user
    user = User.first(username: params['user']['username'])
    if user.nil?
      fail!("Invalid username, doesn't exist!")
      flash.error = ""
    elsif user.authenticate(params['user']['password'])
      flash.success = "Logged in"
      success!(user)
    else
      fail!("Error; try again!")
    end
  end
end

