class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    cannot :manage, :all

    if user.has_role?(:fm_access)
      service_buyer_specific_auth(user)
      service_supplier_specific_auth(user)
      service_admin_specific_auth(user)
    end

    allow_list_specific_auth(user)
    super_admin_specific_auth(user)
  end

  private

  def service_buyer_specific_auth(user)
    return unless user.has_role?(:buyer)

    can :read, FacilitiesManagement
    can :manage, FacilitiesManagement::RM3830::Procurement, user_id: user.id
    can :manage, FacilitiesManagement::RM6232::Procurement, user_id: user.id
    can :manage, FacilitiesManagement::RM3830::ProcurementSupplier, procurement: { user_id: user.id }
    can :manage, FacilitiesManagement::Building, user_id: user.id
  end

  def service_supplier_specific_auth(user)
    return unless user.has_role?(:supplier)

    can :read, FacilitiesManagement::RM3830::SupplierDetail
    can :manage, FacilitiesManagement::RM3830::ProcurementSupplier, supplier: user.supplier_detail
  end

  def service_admin_specific_auth(user)
    return unless user.has_role?(:ccs_employee)

    can :read, :all
    can :manage, FacilitiesManagement::Admin
  end

  def allow_list_specific_auth(user)
    if user.has_role?(:ccs_user_admin)
      can :manage, AllowedEmailDomain
    elsif user.has_role?(:allow_list_access)
      can :read, AllowedEmailDomain
    end
  end

  def super_admin_specific_auth(user)
    return unless user.has_role?(:ccs_developer)

    can :manage, FacilitiesManagement::Framework
  end
end
