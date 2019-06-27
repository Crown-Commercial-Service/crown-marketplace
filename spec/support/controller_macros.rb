module ControllerMacros
  def login_st_buyer
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, confirmed_at: Time.zone.now, roles: %i[buyer st_access])
      sign_in user
    end
  end

  def login_fm_buyer
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, confirmed_at: Time.zone.now, roles: %i[buyer fm_access])
      sign_in user
    end
  end

  def login_mc_buyer
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, confirmed_at: Time.zone.now, roles: %i[buyer mc_access])
      sign_in user
    end
  end

  def login_ls_buyer
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, confirmed_at: Time.zone.now, roles: %i[buyer ls_access])
      sign_in user
    end
  end
end
