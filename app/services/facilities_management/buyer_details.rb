module FacilitiesManagement
  module Beta
    class BuyerDetails
      def save_buyer_details(details, email)
        # always save a new record, leave previous records as audit trail of changes
        # and for use in regeneration of documents using original data should there be a change.
        id = SecureRandom.uuid
        full_name = details['buyer-details-name']
        job_title = details['buyer-details-job-title']
        telephone_number = details['buyer-details-telephone-number']
        organisation_name = details['buyer-details-organisation']
        address_parts = details['buyer-details-postcode-lookup-results'].to_s.split(',')
        central_gov = details['buyer-details-central-government'].to_s == 'on'
        wps = details['buyer-details-wider-public-sector'].to_s == 'on'
        query = "insert into facilities_management_buyer (id,full_name,job_title,telephone_number,organisation_name,organisation_address_line_1,organisation_address_line_2,organisation_address_town,organisation_address_county,organisation_address_postcode,central_government,wider_public_sector,created_at,updated_at,active,email) values('#{id}','#{full_name}','#{job_title}','#{telephone_number}', '#{organisation_name}','#{address_parts[0]}','#{address_parts[1]}','#{address_parts[2]}','#{address_parts[3]}','#{address_parts[4]}',#{central_gov},#{wps},now(),now(),true,'#{email}');"
        exec_query(query)
        id.to_s
      rescue StandardError => e
        Rails.logger.warn "Couldn't save buyer details: #{e}"
        raise e
      end

      def exec_query(query)
        ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
      rescue StandardError => e
        Rails.logger.warn "Couldn't exec_query: #{e}"
        raise e
      end

      def buyer_details(email)
        # get the latest record only, leave previous records as audit trail of changes
        # and for use in regeneration of documents using original data should there be a change.
        query = "select * from facilities_management_buyer where active = true and email = '#{email}' order by created_at DESC limit 1;"
        results = exec_query query
        results
      rescue StandardError => e
        Rails.logger.warn "Couldn't retrieve buyer details: #{e}"
        raise e
      end
    end
  end
end
