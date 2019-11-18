class Order < ApplicationRecord
    belongs_to :batch, optional: true
    enum status: { ready: 0, production: 1, closing: 2, sent: 3} 

    validates :reference, presence: true
    validates :purchase_channel, presence: true
    validates :client_name, presence: true
    validates :adress, presence: true
    validates :delivery_service, presence: true
    validates :total_value, presence: true
    validates :line_items, presence: true
end
