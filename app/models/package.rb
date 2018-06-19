class Package < ApplicationRecord
  has_many :drugs, dependent: :destroy
  def expiration
    date_arr = self.drugs.map(&:expiration_dates).flatten
    return date_arr.map{|date_string| date_string.to_date}.sort.first
  end
  def drug_names
    self.drugs.map(&:name)
  end

  # def as_json(options={})
  #   super(:only => [:id],
  #         :methods => [:drug_names,:expiration]
  #   )
  # end
end
