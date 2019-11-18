class CreateBatches < ActiveRecord::Migration[6.0]
  def change
    create_table :batches do |t|
      t.string :reference_batch
      t.string :purchase_channel_batch

      t.timestamps
    end
  end
end
