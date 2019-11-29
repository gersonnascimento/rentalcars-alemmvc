class CancelScheduledRentalsJob
  attr_reader :limit_date
  def self.auto_enqueue(limit_date)
    Delayed::Job.enqueue(CancelScheduledRentalsJob.new(limit_date))
  end

  def initialize(limit_date)
    @limit_date = limit_date
  end

  def perform
    Rental.scheduled.where("start_date < ?", limit_date).map(&:cancel)
  end
end
