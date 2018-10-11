require 'rails_helper'

RSpec.describe 'db seed data' do
  it 'is loaded without error' do
    load Rails.root.join('db', 'seeds.rb')
  end
end
