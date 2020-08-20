class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    cannot :manage, :all
    if user.has_role? :ccs_admin
      can :manage, :all
    else
      admin_tool_specific_auth(user) if user.has_role? :ccs_employee
      service_specific_auth(user) if user.has_role? :buyer
      fm_supplier_specific_auth(user) if user.has_role?(:fm_access) && user.has_role?(:supplier)
    end
  end

  private

  def service_specific_auth(user)
    can :read, FacilitiesManagement if user.has_any_role? :fm_access
    can :manage, FacilitiesManagement::Procurement, user_id: user.id if user.has_role? :fm_access
    can :manage, FacilitiesManagement::ProcurementSupplier, procurement: { user_id: user.id } if user.has_role? :fm_access
    can :manage, FacilitiesManagement::Building, user_id: user.id if user.has_role? :fm_access
  end

  def admin_tool_specific_auth(user)
    can :read, :all
    can :manage, FacilitiesManagement::Admin if user.has_role? :fm_access
  end

  def fm_supplier_specific_auth(user)
    can :read, FacilitiesManagement::Supplier
    can :manage, FacilitiesManagement::ProcurementSupplier, supplier_email: user.email
  end
end
