class Batch < ApplicationRecord
    has_many :orders
    validates :reference_batch, presence: true
    validates :purchase_channel_batch, presence: true
end
