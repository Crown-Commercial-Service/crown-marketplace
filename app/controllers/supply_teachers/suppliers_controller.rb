module SupplyTeachers
  class SuppliersController < FrameworkController
    helper :telephone_number

    def master_vendors
      @back_path = source_journey.current_step_path
      @suppliers = Supplier.with_master_vendor_rates
    end

    def neutral_vendors
      @back_path = source_journey.current_step_path
      @suppliers = Supplier.with_neutral_vendor_rates
    end

    def all_suppliers
      @back_path = supply_teachers_path
      all_branches = Branch.all
      @branches_count = all_branches.count
      @branches = all_branches.page params[:page]
    end

    private

    def source_journey
      Journey.new('managed-service-provider', managed_service_provider_params)
    end

    def managed_service_provider_params
      params.permit(:looking_for, :managed_service_provider)
    end
  end
end
