module ManagementConsultancy
  class HtmlController < ManagementConsultancy::FrameworkController
    def select_location
      @back_path = :back
    end

    def select_lot
      @back_path = :back
    end

    def select_services
      @back_path = :back
    end

    def supplier_detail
      @back_path = :back
    end

    def download_the_supplier_list
      @back_path = :back
    end
  end
end
