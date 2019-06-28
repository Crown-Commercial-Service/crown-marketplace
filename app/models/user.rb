class User < ApplicationRecord
  include RoleModel
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :registerable, :recoverable

  roles_attribute :roles_mask

  # declare the valid roles -- do not change the order if you add more
  # roles later, always append them at the end!
  roles :buyer, :supplier, :ccs_employee, :ccs_admin, :st_access, :fm_access, :ls_access, :mc_access, :at_access

  attr_accessor :password, :password_confirmation

  def confirmed?
    confirmed_at.present?
  end
end
