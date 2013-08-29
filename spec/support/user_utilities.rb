include ApplicationHelper

def invalid_email
	fill_in "Name",			with: "David A"
	fill_in "Email",		with: "dattar01@gmail"
	fill_in "Password",		with: "foobar"
	fill_in "Confirmation",	with: "foobar"
end

def blank_email
	fill_in "Name",			with: "David A"
	fill_in "Password",		with: "foobar"
	fill_in "Confirmation",	with: "foobar"
end

def short_password
	fill_in "Name",			with: "David A"
	fill_in "Email",		with: "dattar01@gmail.com"
	fill_in "Password",		with: "fooba"
	fill_in "Confirmation",	with: "fooba"
end

def blank_password
	fill_in "Name",			with: "David A"
	fill_in "Email",		with: "dattar01@gmail.com"
end

def confirmation_mismatch
	fill_in "Name",			with: "David A"
	fill_in "Email",		with: "dattar01@gmail.com"
	fill_in "Password",		with: "foobar"
	fill_in "Confirmation",	with: "fooba5"
end

def valid_info
	fill_in "Name",			with: "Example User"
	fill_in "Email",		with: "user@example.com"
	fill_in "Password",		with: "foobar"
	fill_in "Confirmation",	with: "foobar"
end

RSpec::Matchers.define :have_success_message do |message|
	match do |page|
		expect(page).to have_selector('div.alert.alert-success', text: message)
	end
end