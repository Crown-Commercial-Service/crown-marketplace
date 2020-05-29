module ControllerMacros
  def login_st_buyer
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[buyer st_access])
      sign_in user
    end
  end

  def login_fm_admin
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[ccs_employee fm_access])
      sign_in user
    end
  end

  def login_mc_admin
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[ccs_employee mc_access])
      sign_in user
    end
  end

  def login_fm_buyer
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[buyer fm_access])
      sign_in user
      user
    end
  end

  def login_fm_buyer_with_details
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :with_detail, confirmed_at: Time.zone.now, roles: %i[buyer fm_access])
      sign_in user
      user
    end
  end

  def login_mc_buyer
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[buyer mc_access])
      sign_in user
    end
  end

  def login_mc_buyer_with_detail
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :with_detail, confirmed_at: Time.zone.now, roles: %i[buyer mc_access])
      sign_in user
    end
  end

  def login_st_buyer_with_detail
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :with_detail, confirmed_at: Time.zone.now, roles: %i[buyer st_access])
      sign_in user
    end
  end

  def login_ls_buyer
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[buyer ls_access])
      sign_in user
    end
  end
end
