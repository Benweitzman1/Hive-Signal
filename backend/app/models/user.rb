class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :registerable, :validatable

  field :username, type: String
  field :email, type: String, default: ""
  field :encrypted_password, type: String, default: ""

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, if: :password_required?

  before_validation :set_dummy_email

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  def self.validates_email_format_of(*attr_names)
    # Skip email validation
  end

  def self.find_for_authentication(conditions)
    return nil if conditions.blank?

    conditions = conditions.dup
    username = conditions.delete(:username)
    return nil unless username.present?

    find_by(username: username)
  rescue StandardError => e
    Rails.logger.error "Error in find_for_authentication: #{e.message}"
    nil
  end

  private

  def set_dummy_email
    if email.blank? && username.present?
      self.email = "#{username}@dummy.example.com"
    elsif email.blank?
      self.email = "dummy@example.com"
    end
  end
end
