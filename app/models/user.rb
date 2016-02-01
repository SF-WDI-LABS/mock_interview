class User < ActiveRecord::Base
  attr_accessor :reset_token
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # note: has_secure_password automatically adds validations for presence
  # of password, password length < 72 characters, and password_confirmation
  has_secure_password

  # only validate password length on create (not update)
  validates :password, length: { minimum: 6 }, on: :create

  validates :email,
    presence: true,
    uniqueness: true,
    format: {
      with: /@/,
      message: "not a valid format"
    }

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes({ reset_digest: User.digest(reset_token), reset_sent_at: Time.now })
  end

end