module Steps
  class AgencyPayrollResults
    include JourneyStep
    include Results

    attribute :job_type
    attribute :term

    def rates
      Rate.direct_provision.rate_for(job_type: job_type, term: term)
    end

    def rate(branch)
      branch.supplier.rate_for(job_type: job_type, term: term)
    end

    def job_type
      JobType.find_by(code: @job_type)
    end

    def term
      Term.find_by(code: @term)
    end
  end
end
