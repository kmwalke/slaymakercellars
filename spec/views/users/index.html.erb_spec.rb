require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  before(:each) do
    assign(:users, [
             User.create!(
               email: 'Email',
               password: '123',
               name: 'Name'
             ),
             User.create!(
               email: 'Email1',
               password: '123',
               name: 'Name'
             )
           ])
  end

  it 'renders a list of users' do
    render
    assert_select 'tr>td', text: 'Email'.to_s, count: 1
    assert_select 'tr>td', text: 'Email1'.to_s, count: 1
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
  end
end
