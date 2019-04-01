module ManagementConsultancy
  class Journey::ChooseHelpNeeded
    include Steppable

    FRAMEWORKS = %w[
      contingent_labour
      corporate_financial_services
      research_marketplace
      technology_services
      digital_outcomes_and_specialists
      g_cloud
      management_consultants
    ].freeze

    attribute :help_needed
    validates :help_needed, inclusion: {
      in: FRAMEWORKS
    }

    def next_step_class
      case help_needed
      when 'management_consultants'
        Journey::ChooseLot
      else
        Journey::OtherFramework
      end
    end
  end
end
