module ApplicationHelper
  ONE_MILE_IN_METRES = 1609.34

  def miles_to_metres(miles)
    ONE_MILE_IN_METRES * miles
  end

  def metres_to_miles(metres)
    metres / ONE_MILE_IN_METRES
  end
end
