class UploadsController < ApplicationController
  def create
    suppliers = JSON.parse(request.body.read)

    error = nil
    Supplier.transaction do
      begin
        results = suppliers.map do |supplier_data|
          create_supplier(supplier_data)
        end
      rescue ActiveRecord::RecordInvalid => e
        error = e
        raise ActiveRecord::Rollback
      end

      errors = results.select { |r| r.is_a?(Failure) }.map(&:id)

      render json: { errors: errors }, status: :created
    end

    raise error if error
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
