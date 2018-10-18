module ApplicationHelper
  def miles_to_metres(miles)
    DistanceConvertor.miles_to_metres(miles)
  end

  def metres_to_miles(metres)
    DistanceConvertor.metres_to_miles(metres)
  end
end
