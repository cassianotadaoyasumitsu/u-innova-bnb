class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :listing, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :check_in, null: false
      t.datetime :check_out, null: false
      t.string :status, null: false, default: 'pending'
      t.decimal :total_price, null: false, precision: 10, scale: 2

      t.timestamps
    end

    add_index :bookings, [:listing_id, :check_in, :check_out], unique: true
  end
end
