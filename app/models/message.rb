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

  def to_json_hash
    {
      id: id.to_s,
      phone_number: phone_number,
      content: content,
      created_at: created_at.iso8601,
      session_id: session_id
    }
  end
end
