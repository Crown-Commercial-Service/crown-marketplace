class UploadsController < ApplicationController
  def create
    suppliers = JSON.parse(request.body.read)

    error, results = all_or_none(Supplier) do
      suppliers.map do |supplier_data|
        create_supplier(supplier_data)
      end
    end

    raise error if error

    render json: { errors: failure_ids(results) }, status: :created
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

  def failure_ids(results)
    results.select { |r| r.is_a?(Failure) }.map(&:id)
  end

  Success = Class.new
  Failure = Struct.new(:id)

  def create_supplier(data)
    supplier_id = data['supplier_id']
    supplier = Supplier.find_by(id: supplier_id)
    return Failure.new(supplier_id) if supplier.present?

    s = Supplier.create!(id: supplier_id, name: data['supplier_name'])
    data['branches'].each do |branch|
      s.branches.create(postcode: branch['postcode'])
    end
    Success.new
  end
end
