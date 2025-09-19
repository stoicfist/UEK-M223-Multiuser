module AuthHelpers
  DEFAULT_TEST_PASSWORD = "longenough123" # wie in deiner Factory

  def login_as(user, password: DEFAULT_TEST_PASSWORD)
    post sessions_path, params: { email: user.email, password: password }
    expect(response).to redirect_to(root_path) # stelle sicher, dass Login wirklich klappt
    follow_redirect!
  end
end
