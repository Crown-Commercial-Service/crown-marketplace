module SupplyTeachers
  class Journey::MasterVendorManagedService
    include ::Journey::Step

    def inputs
      {
        looking_for: translate_input('supply_teachers.looking_for.managed_service_provider'),
        managed_service_provider: translate_input('supply_teachers.managed_service_provider.master_vendor'),
      }
    end
  end
end
