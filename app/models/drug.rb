class Drug < ApplicationRecord
  belongs_to :package
  validates_presence_of :expiration_dates,:name
  validate :expiration_dates_are_valid
  serialize :expiration_dates, Array


  private
  def expiration_dates_are_valid
    expiration_dates.each do |date|
      if date.blank? || date.nil?
        errors.add :base, "expiration date can't be blank(#{self.name})"
        return
      end
      unless date.strip.match(/^\d{4}\/\d{1,2}\/\d{1,2}/)
        errors.add :base, "expiration date format is invalid(#{self.name})"
        return
      end
      begin
        Date.strptime(date, '%Y/%m/%d')
      rescue => e
        errors.add :base, "expiration date format is invalid(#{self.name})"
        return
      end
    end
  end

end
