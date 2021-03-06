require 'openssl'

class User < ApplicationRecord
  ITERATIONS = 20_000
  DIGEST = OpenSSL::Digest("SHA256").new

  attr_accessor :password

  has_many :questions, dependent: :destroy
  has_many :authored_questions,
           class_name: 'Question', foreign_key: 'author_id',
           dependent: :nullify

  validates :email,
            presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username,
            presence: true, uniqueness: true,
            length: { maximum: 40 }, format: { without: /\W/ }
  validates :password, confirmation: true, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :background_color,
            length: { maximum: 7 }, format: { with: /#\p{XDigit}{6}/}

  before_validation :downcase_username, :downcase_email
  before_save :encrypt_password

  def self.hash_to_string(password_hash)
    password_hash.unpack('H*')[0]
  end

  def self.authenticate(email, password)
    user = find_by(email: email)

    return nil unless user.present?

    hashed_password =
      User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, user.password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )

    user.password_hash == hashed_password ? user : nil
  end

  private

  def downcase_username
    username&.downcase!
  end

  def downcase_email
    email&.downcase!
  end

  def encrypt_password
    if password.present?
      self.password_salt = User.hash_to_string(OpenSSL::Random.random_bytes(16))

      self.password_hash = User.hash_to_string(
        OpenSSL::PKCS5.pbkdf2_hmac(
          password, self.password_salt, ITERATIONS, DIGEST.length, DIGEST
        )
      )
    end
  end
end
