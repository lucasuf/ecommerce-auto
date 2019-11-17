class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :reference
      t.string :purchase_channel
      t.string :client_name
      t.text :adress
      t.string :delivery_service
      t.float :total_value
      t.text :line_items


      t.timestamps
    end
  end
end
