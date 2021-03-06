require "csv"

class User < ApplicationRecord

  # before_save { self.email = email.downcase }
  # validates :name, presence: true, length: { maximum:50 }
  # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # validates :email, presence: true ,length: { maximum:255 }
  # 								,format: { with: VALID_EMAIL_REGEX }
  # 								 ,uniqueness: true
  # has_secure_password
  # validates :password, presence: true , length: {minimun:6}

  # def User.digest(string)
  # 	const = ActiveModel::SecurePassword.min_const?
  # 	BCrypt::engine::MIN_COST :

  # 	BCrypt::engine.const
  # 		BCrypt::password.create(string, cost : cost)

  # end
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save :downcase_email
  #before_save { self.email = email.downcase }

  before_create :create_activation_digest

  has_many :posts
  has_many :posts, dependent: :destroy
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  #activate an account
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  #send activation mail
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_send_at: Time.zone.now)
    #update_attribute(:reset_digest , User.digest(reset_token))
    #update_attribute(:reset_send_at , Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  #return true if password reset has expire

  def password_reset_expired?
    reset_send_at < 2.hours.ago
  end

  #return true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
      BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  #def authenticated?(remember_token)
  #	BCrypt::Password.new(remember_digest).is_password?(remember_token)
  #end

  def forget
    update_attribute(:remember_digest, nil)
  end

  self.per_page = 10

  def feed
    Post.where("user_id = ?", id)
  end

  private

  #convert email to downcase
  def downcase_email
    self.email = email.downcase
  end

  #create and assign activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
