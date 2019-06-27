class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :ccs_admin
      can :manage, :all
    elsif user.has_role? :ccs_employee
      can :read, :all
      can :manage, SupplyTeachers::Admin::Upload
    elsif user.has_role? :supplier
      cannot :manage, :all
      can :read, :all
    elsif user.has_role? :buyer
      cannot :manage, :all
      service_specific_auth(user)
    else
      cannot :manage, :all
    end
  end

  private

  def service_specific_auth(user)
    if user.has_any_role? :fm_access, :mc_access, :ls_access, :at_access
      can :read, FacilitiesManagement
      can :read, ManagementConsultancy
      can :read, LegalServices
      can :read, Apprenticeships
    end
    can :read, SupplyTeachers if user.has_role? :st_access
  end
end
