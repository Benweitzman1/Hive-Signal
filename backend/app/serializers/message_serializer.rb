class MessageSerializer
  def self.serialize(message)
    {
      id: message.id.to_s,
      phone_number: message.phone_number,
      content: message.content,
      created_at: message.created_at.iso8601
    }
  end

  def self.serialize_collection(messages)
    messages.map { |message| serialize(message) }
  end
end

