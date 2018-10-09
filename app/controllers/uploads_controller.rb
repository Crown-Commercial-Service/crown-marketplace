class UploadsController < ApplicationController
  def create
    suppliers = JSON.parse(request.body.read)

    error = nil
    Supplier.transaction do
      begin
        results = suppliers.map do |supplier_json|
          find_or_create_supplier_from_parsed_json(supplier_json)
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

  def find_or_create_supplier_from_parsed_json(json)
    supplier_id = json['supplier_id']
    supplier = Supplier.find_by(id: supplier_id)
    return Failure.new(supplier_id) if supplier.present?

    s = Supplier.create!(id: supplier_id, name: json['supplier_name'])
    json['branches'].each do |branch|
      s.branches.create(postcode: branch['postcode'])
    end
    Success.new
  end
end
