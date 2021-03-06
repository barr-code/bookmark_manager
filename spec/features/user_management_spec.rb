require 'spec_helper'

def sign_up(email = "alice@example.com", password = "oranges!", password_confirmation = "oranges!")
	visit '/users/new'
	expect(page.status_code).to eq(200)
	fill_in :email, :with => email
	fill_in :password, :with => password
	fill_in :password_confirmation, :with => password_confirmation
	click_button "Sign up"
end

def sign_in(email,password)
		visit '/sessions/new'
		fill_in 'email', :with => email
		fill_in 'password', :with => password
		click_button 'Sign in'
end

feature "User signs up" do
	
	scenario "when being logged out" do 
		expect{ sign_up }.to change(User, :count).by(1)
		expect(page).to have_content("Welcome, alice@example.com")
		expect(User.first.email).to eq("alice@example.com")
	end

	scenario "with a password that doesn't match" do 
		expect { sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
		expect(current_path).to eq('/users')
		expect(page).to have_content("Sorry, your passwords don't match.")
	end

	scenario "with an email that is already registered" do 
		expect {sign_up}.to change(User, :count).by(1)
		expect {sign_up}.to change(User, :count).by(0)
		expect(page).to have_content("This email is already taken")
	end
end

feature "User signs in" do 
	before(:each) do 
		User.create(:email => "test@test.com",
			:password => 'test',
			:password_confirmation => 'test')
	end

	scenario "with correct credentials" do 
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com', 'test')
		expect(page).to have_content("Welcome, test@test.com")
	end

	scenario "with incorrect credentials" do 
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com', 'wrong')
		expect(page).not_to have_content("Welcome, test@test.com")
	end
end

feature "User signs out" do 

	before(:each) do 
		User.create(:email => "test@test.com", :password => 'test', :password_confirmation => 'test')
	end

	scenario "while being signed in" do 
		sign_in('test@test.com', 'test')
		click_button "Sign out"
		expect(page).to have_content("Good bye!")
		expect(page).not_to have_content("Welcome, test@test.com")
	end
end

def reset_request(email)
	visit '/users/reset_password'
	fill_in('email', :with => email)
	click_button("Reset Password")
end

feature "User forgets password" do
	before(:each) do 
		User.create(:email => "test@test.com", :password_token => 'LoLu4gotyrPasswrd')
	end

	scenario "while at sign in" do
		visit '/sessions/new'
		click_on("Forgotten password?")
		expect(current_path).to eq('/users/reset_password')
	end

	scenario "submitting email" do
		reset_request('test@test.com')
		expect(page).to have_content("A password reset code has been sent test@test.com. Please check your email.")	
	end

	scenario "clicking reset link" do
		visit 'users/new_password?token=LoLu4gotyrPasswrd'
		expect(page).to have_content "Please choose a new password."
	end
end
