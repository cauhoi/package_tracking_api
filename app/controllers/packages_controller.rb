class PackagesController < ApplicationController
  def index
    response_arr = []
    Package.all.each do |item|
      response_arr << {id: item.id,drugs: item.drug_names,expiration: item.expiration.try(:strftime,'%Y/%m/%d')}
    end
    render json: {package: response_arr}.to_json
  end
  def create
    drugs =  params[:package][:drugs]
    package = Package.new
    Array(drugs).each do |drug|
      drug_name = drug[:name].downcase if drug[:name]
      expiration = Array(drug[:expiration_dates])
      package.drugs.build(name: drug_name, expiration_dates: expiration)
    end
    if package.save
      render json: package, status: :created
    else
      error_message = package.drugs.map{|drug| drug.errors.full_messages}
      render json: {errors: error_message}, status: :unprocessable_entity
    end
  end

  def update
    drugs =  params[:package][:drugs]
    Array(drugs).each do |drug|
      drug_name = drug[:name].downcase if drug[:name]
      expiration = Array(drug[:expiration_dates])
      drug_to_update = Drug.where(name: drug_name, package_id: params[:id]).first
      if drug_to_update
        if drug_to_update.update_attributes(expiration_dates: expiration)
          render json: drug_to_update, status: :ok
        else
          render json: {errors: drug_to_update.errors.full_messages}, status: :unprocessable_entity
        end
      else
        render json: {errors: "Record Not Found"}, status: :unprocessable_entity
      end
    end
  end

end
