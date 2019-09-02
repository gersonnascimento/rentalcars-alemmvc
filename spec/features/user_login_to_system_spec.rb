require 'rails_helper'

feature 'User login to system' do 
  scenario 'successfully' do
    user = create(:user)
    visit root_path

    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Log in'

    expect(page).to have_content(user.email)
    expect(page).to have_link('Logout')
  end


  scenario 'and log out' do
    user = create(:user)

    visit root_path
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Log in'
    click_on 'Logout'

    expect(page).not_to have_content(user.email)
    expect(page).to have_link('Login')
  end
end
