class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    suppliers = JSON.parse(request.body.read)

    Supplier.destroy_all

    error, results = all_or_none(Supplier) do
      suppliers.map do |supplier_data|
        create_supplier(supplier_data)
      end
    end

    raise error if error

    render json: { errors: skipped_ids(results) }, status: :created
  end

  def all_or_none(transaction_class)
    error = results = nil
    transaction_class.transaction do
      results = yield
    rescue ActiveRecord::RecordInvalid => e
      error = e
      raise ActiveRecord::Rollback
    end
    [error, results]
  end

  def skipped_ids(results)
    results.select { |r| r.is_a?(Skipped) }.map(&:id)
  end

  Success = Class.new
  Skipped = Struct.new(:id)

  def create_supplier(data)
    supplier_id = data['supplier_id']
    branches = data.fetch('branches', [])
    supplier = Supplier.find_by(id: supplier_id)
    return Skipped.new(supplier_id) if supplier.present?

    s = Supplier.create!(id: supplier_id, name: data['supplier_name'])
    branches.each do |branch|
      contact_name = branch.dig('contacts', 0, 'name')
      contact_email = branch.dig('contacts', 0, 'email')
      s.branches.create!(
        postcode: branch['postcode'],
        contact_name: contact_name,
        contact_email: contact_email
      )
    end
    Success.new
  end
end
