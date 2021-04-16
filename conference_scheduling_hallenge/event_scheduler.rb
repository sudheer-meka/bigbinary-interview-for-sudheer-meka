require 'json'
require_relative './lib/event'
require_relative './lib/track'

class EventScheduler
  def initialize(events)
    @events = events
    @tracks = [Track.new, Track.new]
  end

  def execute
    schedule_events
    schedule_lightning_events
    print_events
  end

  private

  attr_accessor :events, :tracks

  def missed_events
    @missed_events ||= events.reject(&:starts_at)
  end

  def lightning_events
    @lightning_events ||= events.select(&:is_lightning)
  end

  def print_events
    tracks.each_with_index do |track, index|
      puts "Track #{index + 1}----------------------------"
      track.events.sort_by(&:starts_at).map(&:to_s)
    end

    return if missed_events.empty?

    puts 'Missed Events==================================='
    missed_events.map(&:to_s)
  end

  def schedule_events
    events.sort_by(&:duration).each do |event|
      next if event.lightning?

      tracks.each do |track|
        break track.add(event, event.duration) if track.available? event.duration
      end
    end
  end

  def schedule_lightning_events
    lightning_duration = lightning_events.sum(&:duration)

    return unless obj = tracks.find { |track| track.available? lightning_duration }

    lightning_events.each do |event|
      obj.add(event, event.duration)
    end
  end
end

# driver program
file = File.open './mappers/events.json'
events = (JSON.load file).map { |data| Event.new(data) }
scheduler = EventScheduler.new(events)
scheduler.execute
