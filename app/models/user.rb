class User < ApplicationRecord
    validates :skill_level, inclusion: { in: %w(beginner intermediate expert) }
    has_many :subscriptions, dependent: :destroy
    has_many :posts, dependent: :destroy
    has_many :forums, through: :subscriptions, dependent: :destroy
end
