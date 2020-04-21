module CcsPatterns
  class DbdataController < FrameworkController
    skip_before_action :authenticate_user!

    def index
      @migration_list = ActiveRecord::Base.connection.execute('select * from schema_migrations order by version desc')
      @view_list = ActiveRecord::Base.connection.execute('select * from INFORMATION_SCHEMA.views WHERE table_schema = ANY (current_schemas(false))')
      @advisory_locks = ActiveRecord::Base.connection.execute('SELECT pid, locktype, mode FROM pg_locks')
      @kill_message = params[:kill_message]
    end

    def killpid
      kill_message = ActiveRecord::Base.connection.execute("SELECT pg_terminate_backend(#{params[:id]})").first[0]
      redirect_to action: :index, kill_message: kill_message
      rescue StandardError => e
        redirect_to action: :index, kill_message: e.message
    end
  end
end
