ActionController::Renderers.add :xlsx do |obj, options|
  filename = options[:filename] || 'data'
  send_data obj, type: Mime[:xlsx], disposition: "attachment; filename=#{filename}.xlsx"
end
