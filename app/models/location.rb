class Location
  attr_reader :postcode, :point, :error

  def initialize(postcode)
    @postcode = UKPostcode.parse(postcode)
    @point = Geocoding.new.point(postcode: @postcode.to_s) if @postcode.valid?
  end

  def valid?
    @error = 'Postcode is invalid' unless @postcode.valid?
    !@error
  end
end
