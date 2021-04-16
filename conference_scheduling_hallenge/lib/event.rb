class Event
  attr_accessor :name, :duration, :is_lightning, :starts_at

  def initialize(data)
    @name = data['name']
    @duration = data['duration']
    @is_lightning = data['is_lightning']
    @starts_at = nil
  end

  def lightning?
    is_lightning
  end

  def to_s
    puts "#{starts_at&.strftime('%I:%M %p')} #{name} #{duration} min".strip
  end
end
