module FacilitiesManagement
  module RM3830
    class Service
      include Virtus.model
      include StaticRecord

      attribute :code, String
      attribute :name, String
      attribute :work_package_code, String
      attribute :mandatory, Axiom::Types::Boolean

      def work_package
        WorkPackage.find_by(code: work_package_code)
      end

      def mandatory?
        mandatory
      end

      def self.all_codes
        all.map(&:code)
      end

      def self.special_da_service?(code)
        ['M.1', 'N.1', 'O.1'].include? code
      end

      # FacilitiesManagement::RM3830::Service.gia_services
      def self.gia_services
        # 'G-1' and 'G-3' are should be included in this list, but they are handled as special cases
        %w[C.1 C.10 C.11 C.12 C.13 C.14 C.15 C.16 C.17 C.18 C.2 C.20 C.3 C.4 C.6 C.7 C.8 C.9 E.1 E.2 E.3 E.5 E.6 E.7 E.8 F.1 G.10 G.11 G.14 G.15 G.16 G.2 G.4 G.6 G.7 G.9 H.1 H.10 H.11 H.13 H.2 H.3 H.6 H.7 H.8 H.9 J.10 J.11 J.7 J.9 L.2 L.3 L.4 L.5]
      end

      def self.full_gia_services
        gia_services + %w[G.1 G.3]
      end

      # FacilitiesManagement::RM3830::Service.direct_award_services
      def self.direct_award_services(procurement_id)
        frozen_rate = FrozenRate.where(facilities_management_rm3830_procurement_id: procurement_id)

        return frozen_rate.where(direct_award: true).map(&:code) if frozen_rate.exists?

        Rate.all.where(direct_award: true).map(&:code) unless frozen_rate.exists?
      end
    end

    Service.load_csv('facilities_management/rm3830/services.csv')
  end
end
