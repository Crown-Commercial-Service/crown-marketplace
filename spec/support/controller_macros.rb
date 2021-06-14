module ControllerMacros
  def login_fm_admin
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[ccs_employee fm_access])
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

  def login_fm_supplier
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[supplier fm_access])
      sign_in user
    end
  end

  def login_buyer_without_permissions
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :with_detail, confirmed_at: Time.zone.now, roles: %i[buyer])
      sign_in user
      user
    end
  end

  def login_crown_marketplcae_admin
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[ccs_employee allow_list_access])
      sign_in user
    end
  end

  def login_crown_marketplcae_read_only
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :without_detail, confirmed_at: Time.zone.now, roles: %i[allow_list_access])
      sign_in user
    end
  end
end
