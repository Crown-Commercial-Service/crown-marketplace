module LegalServices
  class Journey::SupplierResults2
    include Steppable
    def next_step_class
      Journey::DownloadShortlist
    end
  end
end
