class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :content, type: String
  field :session_id, type: String
  field :phone_number, type: String

  validates :content, presence: true
  validates :session_id, presence: true
  validates :phone_number, presence: true

  scope :by_session, ->(session_id) { where(session_id: session_id).desc(:created_at) }
end
