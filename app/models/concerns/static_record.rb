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
  end
end
