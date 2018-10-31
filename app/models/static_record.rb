require 'csv'

module StaticRecord
  def self.included(base)
    base.send :include, ActiveModel::Model
    base.extend ClassMethods
  end

  module ClassMethods
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

    def find_by(arg)
      all.find { |term| arg.all? { |k, v| term.public_send(k) == v } }
    end

    def where(arg)
      all.select { |term| arg.all? { |k, v| term.public_send(k) == v } }
    end

    def load_csv(filename)
      define(*CSV.read(Rails.root.join('data', filename)))
    end
  end
end
