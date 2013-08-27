require 'spec_helper'

describe "UserPages" do

	subject { page }

	describe "signup page" do
		before { visit signup_path }
		it { should have_content('Sign up') }
		it { should have_title(full_title('Sign up')) }

		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				before { click_button submit }
				it { should have_title('Sign up') }
				it { should have_content('error') }
			end

		end

		describe "with invalid email" do
			before do
				fill_in "Name",			with: "David A"
				fill_in "Email",		with: "dattar01@gmail"
				fill_in "Password",		with: "foobar"
				fill_in "Confirmation",	with: "foobar"
			end
			
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
			
			describe "after submission" do
				before { click_button submit }
				it { should have_title('Sign up') }
				it { should have_content('Email is invalid') }
			end
		end

		describe "with blank email" do
			before do
				fill_in "Name",			with: "David A"
				fill_in "Password",		with: "foobar"
				fill_in "Confirmation",	with: "foobar"
			end

			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				before { click_button submit }
				it { should have_title('Sign up') }
				it { should have_content('Email is invalid') }
				it { should have_content("Email can't be blank") }
			end
		end

		describe "password too short" do
			before do
				fill_in "Name",			with: "David A"
				fill_in "Email",		with: "dattar01@gmail.com"
				fill_in "Password",		with: "fooba"
				fill_in "Confirmation",	with: "fooba"
			end

			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				before { click_button submit }
				it { should have_title('Sign up') }
				it { should have_content('Password is too short') }
			end
		end

		describe "password blank" do
			before do
				fill_in "Name",			with: "David A"
				fill_in "Email",		with: "dattar01@gmail.com"
			end

			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				before { click_button submit }
				it { should have_title('Sign up') }
				it { should have_content('Password is too short') }
				it { should have_content("Password can't be blank") }
			end
		end

		describe "confirmation doesn't match" do
			before do
				fill_in "Name",			with: "David A"
				fill_in "Email",		with: "dattar01@gmail.com"
				fill_in "Password",		with: "foobar"
				fill_in "Confirmation",	with: "fooba5"
			end

			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				before { click_button submit }
				it { should have_title('Sign up') }
				it { should have_content("Password confirmation doesn't match Password") }
			end
		end

		describe "with valid information" do
			before do
				fill_in "Name",			with: "Example User"
				fill_in "Email",		with: "user@example.com"
				fill_in "Password",		with: "foobar"
				fill_in "Confirmation",	with: "foobar"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving the user" do
				before { click_button submit }
				let(:user) { User.find_by(email: 'user@example.com') }

				it { should have_link('Sign out') }
				it { should have_title(user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }
			end
		end
	end
	
	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }

		it { should have_content(user.name) }
		it { should have_title(user.name) }
	end

end