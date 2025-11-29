class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## Database authenticatable
  field :username,           type: String
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def email_required?
    false
  end

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  # Override Devise's find_for_authentication to use username instead of email
  def self.find_for_authentication(conditions)
    conditions = conditions.dup
    username = conditions.delete(:username)
    find_by(username: username) if username.present?
  end
end
