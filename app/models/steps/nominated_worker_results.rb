module Steps
  class NominatedWorkerResults
    include JourneyStep
    include Results

    def rates
      Rate.direct_provision.nominated_worker
    end

    def rate(branch)
      branch.supplier.nominated_worker_rate
    end
  end
end
