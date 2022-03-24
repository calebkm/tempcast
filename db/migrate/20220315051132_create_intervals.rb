class CreateIntervals < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' # Enable UUID in PostgreSQL

    create_table :intervals, id: :uuid do |t|
      t.string   :forecast_id, null: false
      t.datetime :timestamp,   null: false
      t.integer  :code,        null: false
      t.float    :temperature, null: false
      t.float    :min,         null: false
      t.float    :max,         null: false

      t.timestamps

      t.index :forecast_id
    end
  end
end
