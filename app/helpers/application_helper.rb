module ApplicationHelper
  def miles_to_metres(miles)
    1609.34 * miles
  end

  def metres_to_miles(metres)
    metres / 1609.34
  end
end
