class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :phone_number, type: String

  belongs_to :user

  validates :content, presence: true
  validates :phone_number, presence: true
  validates :user_id, presence: true

  scope :by_user, ->(user_id) { where(user_id: user_id).desc(:created_at) }
end
