test 'sign up and log in user one' do
    user_one = { email: 'userone@test.com', password: 'password' }
    sign_up(user_one)
    assert_response :success

    (user_one)
    assert_response :success
end
