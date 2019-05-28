module DistributedLocks
  def self.distributed_lock(lock_number)
    # 'SELECT pg_try_advisory_lock_shared(1234);'
    query = "SELECT pg_try_advisory_lock(#{lock_number});"
    lock = false
    ActiveRecord::Base.connection_pool.with_connection do |db|
      result = db.exec_query query
      # puts "Distributed lock #{result}"
      lock = result[0]['pg_try_advisory_lock']
    end

    return unless lock

    begin
      yield
    ensure
      distributed_unlock(lock_number)
    end
  end

  def self.distributed_unlock(lock_number)
    # 'SELECT pg_advisory_unlock_shared(1234);'
    query = "SELECT pg_advisory_unlock(#{lock_number});"
    ActiveRecord::Base.connection_pool.with_connection do |db|
      result = db.exec_query query
      # puts "Distributed unlock #{result}"
      return result[0]['pg_try_advisory_lock']
    end
  end
end
