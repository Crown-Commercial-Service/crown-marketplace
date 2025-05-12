module DistributedLocks
  def self.distributed_lock(lock_number)
    query = "SELECT pg_try_advisory_lock(#{lock_number});"
    lock = false
    ActiveRecord::Base.connection_pool.with_connection do |db|
      result = db.exec_query query

      lock = result[0]['pg_try_advisory_lock']
    end

    return false unless lock

    begin
      yield
    ensure
      distributed_unlock(lock_number)
    end

    true
  end

  def self.distributed_unlock(lock_number)
    query = "SELECT pg_advisory_unlock(#{lock_number});"
    ActiveRecord::Base.connection_pool.with_connection do |db|
      result = db.exec_query query

      return result[0]['pg_try_advisory_lock']
    end
  end
end
