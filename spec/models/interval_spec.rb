require 'rails_helper'

RSpec.describe Interval, type: :model do
  context 'validation tests' do
    it 'requires timestamp presence' do
      is_valid = Interval.new(code: '1000', temperature: '73.4', max: '76.4', min: '72.1').save
      expect(is_valid).to eq(false)
    end

    it 'requires code presence' do
      is_valid = Interval.new(timestamp: DateTime.now, temperature: '73.4', max: '76.4', min: '72.1').save
      expect(is_valid).to eq(false)
    end

    it 'requires temperature presence' do
      is_valid = Interval.new(code: '1000', timestamp: DateTime.now, max: '76.4', min: '72.1').save
      expect(is_valid).to eq(false)
    end

    it 'requires max presence' do
      is_valid = Interval.new(code: '1000', timestamp: DateTime.now, temperature: '73.4', min: '72.1').save
      expect(is_valid).to eq(false)
    end

    it 'requires min presence' do
      is_valid = Interval.new(code: '1000', timestamp: DateTime.now, temperature: '73.4', max: '76.4',).save
      expect(is_valid).to eq(false)
    end
  end

  context 'associations tests' do
    it 'should belong_to forecast' do
      # https://api.rubyonrails.org/classes/ActiveRecord/Reflection/ClassMethods.html
      interval = Interval.reflect_on_association(:forecast)
      expect(interval.macro).to eq(:belongs_to)
    end
  end
end
