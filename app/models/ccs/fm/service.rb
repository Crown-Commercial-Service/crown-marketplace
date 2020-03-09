module CCS
  module FM
    class Service < ApplicationRecord
      def self.table_name_prefix
        'fm_'
      end

      # usage
      # CCS::FM::Service.gia_services
      def self.gia_services
        # 'G-1' and 'G-3' are should be included in this list, but they are handled as special cases
        %w[C.1 C.10 C.11 C.12 C.13 C.14 C.15 C.16 C.17 C.18 C.2 C.20 C.3 C.4 C.6 C.7 C.8 C.9 D.1 D.2 D.4 D.5 D.6 E.1 E.2 E.3 E.5 E.6 E.7 E.8 F.1 G.10 G.11 G.14 G.15 G.16 G.2 G.4 G.6 G.7 G.9 H.1 H.10 H.11 H.13 H.2 H.3 H.6 H.7 H.8 H.9 J.10 J.11 J.7 J.9 L.2 L.3 L.4 L.5]
      end

      # usage
      # CCS::FM::Service.direct_award_services
      # TBC: move this into the Database table work_packages !
      def self.direct_award_services
        CCS::FM::Rate.all.where(direct_award: true).map(&:code)
      end

      def self.further_competition_services
        CCS::FM::Rate.all.where(direct_award: false).map(&:code)
      end
    end
  end
end
