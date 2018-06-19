class CreateDrugs < ActiveRecord::Migration[5.2]
  def change
    create_table :drugs do |t|
      t.references :package, foreign_key: true
      t.string :name
      t.text :expiration_dates

      t.timestamps
    end
  end
end
