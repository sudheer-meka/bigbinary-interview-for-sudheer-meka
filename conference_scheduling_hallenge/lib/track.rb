require_relative './utils/integer'

class Track
  START_AT = Time.new(2022, 12, 25, 9, 0, 0)
  END_AT = Time.new(2022, 12, 25, 17, 0, 0)
  INTERVAL_START_AT = Time.new(2022, 12, 25, 12, 0, 0)
  INTERVAL_END_AT = Time.new(2022, 12, 25, 13, 0, 0)

  attr_accessor :morning_booked_till, :afternoon_booked_till, :events

  def initialize
    @morning_booked_till = START_AT
    @afternoon_booked_till = INTERVAL_END_AT
    @events = []
  end

  def morning_available?(duration)
    morning_booked_till + duration.minutes <= INTERVAL_START_AT
  end

  def afternoon_available?(duration)
    afternoon_booked_till + duration.minutes <= END_AT
  end

  def add(event, duration)
    if morning_available?(duration)
      event.starts_at = morning_booked_till
      events << event
      self.morning_booked_till += duration.minutes
      return
    end

    event.starts_at = afternoon_booked_till
    events << event
    self.afternoon_booked_till += duration.minutes
  end

  def available?(duration)
    morning_available?(duration) || afternoon_available?(duration)
  end
end
