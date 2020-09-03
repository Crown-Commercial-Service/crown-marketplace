# To make Kaminari and Will Paginate play nicely together
# See https://stackoverflow.com/questions/14524091/why-this-pagination-doesnt-work-when-using-kaminari
if defined?(WillPaginate)
  module WillPaginate
    module ActiveRecord
      module RelationMethods
        def per(value = nil)
          per_page(value)
        end

        def total_count
          count
        end
      end
    end

    module CollectionMethods
      alias_method :num_pages, :total_pages
    end
  end
end
