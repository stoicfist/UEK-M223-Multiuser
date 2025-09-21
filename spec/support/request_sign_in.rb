module RequestSignIn
  def sign_in(user)
    @__auth_headers__ ||= {}
    @__auth_headers__['rack.session'] ||= {}
    @__auth_headers__['rack.session']['user_id'] = user.id
  end

  def auth_headers
    @__auth_headers__ || {}
  end
end

RSpec.configure do |config|
  config.include RequestSignIn, type: