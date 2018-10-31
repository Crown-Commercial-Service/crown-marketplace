module StaticRecord
  def self.included(base)
    base.send :include, ActiveModel::Model
    base.extend ClassMethods
  end

  module ClassMethods
    def define(keys, entries)
      entries.each do |entry|
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
  end
end
