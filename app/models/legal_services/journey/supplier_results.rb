module LegalServices
  class Journey::SupplierResults
    include Steppable
    def next_step_class
      Journey::DownloadShortlist
    end
  end
end
