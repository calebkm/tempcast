class CreateForecasts < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' # Enable UUID in PostgreSQL

    create_table :forecasts, id: :uuid do |t|
      t.string :zipcode, null: false

      t.timestamps

      t.index :zipcode
    end
  end
end
