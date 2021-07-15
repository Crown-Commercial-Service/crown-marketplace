class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    cannot :manage, :all
    if user.has_role? :ccs_admin
      can :manage, :all
    else
      admin_tool_specific_auth(user)
      service_specific_auth(user)
      fm_supplier_specific_auth(user)
      allow_list_specific_auth(user)
    end
  end

  private

  def service_specific_auth(user)
    return unless user.has_role?(:buyer) && user.has_role?(:fm_access)

    can :read, FacilitiesManagement
    can :manage, FacilitiesManagement::RM3830::Procurement, user_id: user.id
    can :manage, FacilitiesManagement::RM3830::ProcurementSupplier, procurement: { user_id: user.id }
    can :manage, FacilitiesManagement::Building, user_id: user.id
  end

  def admin_tool_specific_auth(user)
    return unless user.has_role?(:fm_access) && user.has_role?(:ccs_employee)

    can :read, :all
    can :manage, FacilitiesManagement::Admin
    can :manage, FacilitiesManagement::RM3830::Admin::ManagementReport
    can :manage, FacilitiesManagement::RM3830::Admin::Upload
  end

  def fm_supplier_specific_auth(user)
    return unless user.has_role?(:fm_access) && user.has_role?(:supplier)

    can :read, FacilitiesManagement::RM3830::SupplierDetail
    can :manage, FacilitiesManagement::RM3830::ProcurementSupplier, supplier: user.supplier_detail
  end

  def allow_list_specific_auth(user)
    return unless user.has_role?(:allow_list_access)

    if user.has_role?(:ccs_employee)
      can :manage, AllowedEmailDomain
    else
      can :read, AllowedEmailDomain
    end
  end
end
