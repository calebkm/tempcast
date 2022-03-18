class Interval < ApplicationRecord
  validates :timestamp, :code, :temperature, :max, :min, presence: true

  belongs_to :forecast
end
