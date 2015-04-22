class User
  include DataMapper::Resource
  include BCrypt

  before :save, :generate_token
  before :create, :generate_token

  property :id          ,Serial
  property :username    ,String       ,length: 0..50
  property :password    ,BCryptHash
  property :token       ,String       ,length: 0..100
  property :created     ,DateTime
  property :updated     ,DateTime

  def generate_token
    self.token = BCrypt::Engine.generate_salt if self.token.nil?
  end

  def authenticate(pass)
    self.password == pass
  end

end