require 'spec_helper'

describe "Static pages" do
  
  subject { page }
  
  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }

    it "should have the right links on the layout" do
      click_link "About"
      expect(page).to have_title(full_title('About Us'))
      click_link "Contact"
      expect(page).to have_title(full_title('Contact'))
      click_link "Help"
      expect(page).to have_title(full_title('Help'))
      click_link "Home"
      expect(page).to have_title(full_title(''))
      click_link "Sign up now!"
      expect(page).to have_title(full_title('Sign up'))
      click_link "sample app"
      expect(page).to have_title(full_title(''))
    end
  end

  describe "Home page" do
    before { visit root_path }

    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title ('| Home')}

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let!(:micropost1) { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") }
      let!(:micropost2) { FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet") }
      before do
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      it { should have_content("2 microposts") }

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "after 1 micropost" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:micropost) { FactoryGirl.create(:micropost, user: user, content: "Hello!") }
    before do
      sign_in user
      visit root_path
    end
    
    it "should have the right number of microposts and proper pluralization" do
      expect(page).to have_content("1 micropost")
    end
  end

  # describe "micropost pagination" do
  #   let(:user) { FactoryGirl.create(:user) }
  #   before do
  #     50.times do |i|
  #       content = "Lorem ipsum #{i}"
  #       user.microposts.create!(content: content)
  #     end
  #     visit root_path
  #   end

  #   it "should only include the first 30 microposts" do
  #     expect(page).to have_content("Lorem ipsum")
  #   end
  # end

  describe "delete links only appear for user who created them" do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let!(:micropost1) { FactoryGirl.create(:micropost, user: user1, content: "User 1 micropost") }

    before do
      sign_in user2
      visit root_path
    end

    it "should not have delete links" do
      expect(page).not_to have_content("User 1 micropost")
    end
  end
  
  describe "Help page" do
    before { visit help_path }

    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end
  
  describe "About page" do
    
    before { visit about_path }

    let(:heading) { 'About Us' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end
  
  describe "Contact page" do
    
    before { visit contact_path }

    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end
  
end
