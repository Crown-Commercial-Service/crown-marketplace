ActionController::Renderers.add :xlsx do |obj, options|
  filename = options[:filename] || 'data'
  str = obj.respond_to?(:to_xlsx) ? obj.to_xlsx : obj.to_s
  send_data str, type: Mime[:xlsx], disposition: "attachment; filename=#{filename}.xlsx"
end
