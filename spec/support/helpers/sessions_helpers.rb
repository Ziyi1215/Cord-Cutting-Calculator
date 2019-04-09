module SessionsHelpers
    def sign_up_with(username, email, password)
      visit signup_path
      fill_in 'Username', with: username
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Sign up'
    end
end