require 'csv'

module StaticRecord
  extend ActiveSupport::Concern
  include ActiveModel::Model

  class_methods do
    def define(*entries)
      keys = entries.first
      entries.drop(1).each do |entry|
        all << new(
          keys.zip(entry).to_h
        ).freeze
      end
      all.freeze
    end

    def all
      @all ||= []
    end

    def count
      all.length
    end

    def find_by(arg)
      all.find { |term| arg.all? { |k, v| term.public_send(k) == v } }
    end

    def where(arg)
      all.select do |term|
        arg.all? { |k, v| [*v].include?(term.public_send(k)) }
      end
    end

    def load_csv(filename)
      define(*CSV.read(Rails.root.join('data', filename)))
    end

    # factory method
    # each row of data in the database is used to create a new object
    def load_db(query)
      res = ActiveRecord::Base.connection_pool.with_connection { |con| con.exec_query(query) }
      @all = []
      res.each do |row|
        @all << new(row).freeze
      end
      @all.freeze
    end
  end
end
