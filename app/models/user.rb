class User < ApplicationRecord
  include RoleModel

  has_many  :procurements,
            foreign_key: :user_id,
            inverse_of: :user,
            class_name: 'FacilitiesManagement::Procurement',
            dependent: :destroy

  has_one :buyer_detail,
          foreign_key: :user_id,
          inverse_of: :user,
          class_name: 'FacilitiesManagement::BuyerDetail',
          dependent: :destroy

  has_one :supplier_detail,
          foreign_key: :user_id,
          inverse_of: :user,
          class_name: 'FacilitiesManagement::SupplierDetail',
          dependent: :destroy

  has_many :buildings,
           foreign_key: :user_id,
           class_name: 'FacilitiesManagement::Building',
           inverse_of: :user,
           dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :trackable and :omniauthable
  devise :registerable, :recoverable, :timeoutable

  roles_attribute :roles_mask

  # declare the valid roles -- do not change the order if you add more
  # roles later, always append them at the end!
  roles :buyer, :supplier, :ccs_employee, :ccs_admin, :st_access, :fm_access, :ls_access, :mc_access, :at_access

  attr_accessor :password, :password_confirmation

  def confirmed?
    confirmed_at.present?
  end

  def fm_buyer_details_incomplete?
    # used to assist the site in determining if the user
    # is a buyer and if they are required to complete information in
    # the buyer-account details page

    if has_role? :buyer
      !(buyer_detail.present? && buyer_detail&.valid?(:update))
    else
      false
    end
  end
end
