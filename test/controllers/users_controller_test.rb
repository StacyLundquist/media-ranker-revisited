require "test_helper"

describe UsersController do
  describe "auth_callback" do
    it "logs in an existing user and redirects to the root route" do
      user = users(:dan)
      expect {
        perform_login(user)
      }.wont_change 'User.count'

      must_redirect_to root_path
      session[:user_id].must_equal user.id
    end

    it "creates an account for a new user and redirects to the root route" do
      new_user = User.new(
          username: 'aName',
          provider: 'github',
          email: 'name@namesplace.com',
          uid: 123
      )

      expect {
        perform_login(new_user)
      }.must_change 'User.count', 1

      must_redirect_to root_path
      session[:user_id].must_equal User.last.id
    end

    it "redirects to the login route if given invalid user data" do
      new_user = User.new(
          username: nil,
          provider: 'github',
          email: 'someone@somewhere.com',
          uid: 123
      )

      expect {
        perform_login(new_user)
      }.wont_change 'User.count'

      must_redirect_to root_path
      assert_nil(session[:user_id])

      user = User.find_by(uid: new_user.uid, provider: new_user.provider)
      assert_nil(user)
    end
  end
end
