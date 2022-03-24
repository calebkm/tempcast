class Forecast < ApplicationRecord
  validates :zipcode, presence: true

  has_many :intervals, -> { order 'timestamp ASC' }, dependent: :destroy

  # A forecast is considered "cached" if it less than 30 minutes old
  scope :cached, -> { where(created_at: 30.minutes.ago..DateTime.now) }

  # Returns the current forecast detail
  # NOTE: This function depends on the intervals being ordered ASC.
  def current
    intervals.first
  end

  # Returns a list of extended forecast details
  # NOTE: This function depends on the intervals being ordered ASC.
  def extended
    intervals[1..-1]
  end
end
