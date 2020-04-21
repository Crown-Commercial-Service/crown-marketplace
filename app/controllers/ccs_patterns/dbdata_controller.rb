module CcsPatterns
  class DbdataController < FrameworkController
    skip_before_action :authenticate_user!

    def index
      @migration_list = ActiveRecord::Base.connection.execute("select * from schema_migrations order by version desc")
      @view_list = ActiveRecord::Base.connection.execute("select * from INFORMATION_SCHEMA.views WHERE table_schema = ANY (current_schemas(false))")
    end
  end
end
