class Location
  attr_reader :postcode, :point, :error

  def initialize(postcode)
    @postcode = UKPostcode.parse(postcode)
    @point = Geocoding.new.point(postcode: @postcode.to_s) if @postcode.valid?
  end

  def valid?
    if !@postcode.valid?
      @error = 'Postcode is invalid'
    elsif !@point
      @error = "Couldn't find that postcode"
    end

    !@error
  end
end
