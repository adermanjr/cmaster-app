class Usuario < ApplicationRecord
  has_many :pombos, dependent: :destroy
  has_many :pombals, dependent: :destroy
  has_many :tratamentos
  has_many :planos
  has_many :competicaos
  has_many :provas
  has_many :resultados
  has_many :equipes
  has_many :preparos
  has_many :prova_preparos
  has_many :preparos, through: :prova_preparos
  
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  
  validates :nome,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  # Returns the hash digest of the given string.
  def Usuario.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # Returns a random token.
  def Usuario.new_token
    SecureRandom.urlsafe_base64
  end
  
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = Usuario.new_token
    update_attribute(:remember_digest, Usuario.digest(remember_token))
  end
  
  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def key
    self.id
  end
  
  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    restore_activation_digest
    UserMailer.account_activation(self).deliver_now
  end
  
  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = Usuario.new_token
    update_columns(reset_digest: Usuario.digest(reset_token), reset_sent_at: Time.zone.now)
  end
  
  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 36.hours.ago
  end
  
  private

    # Converts email to all lower-case.
    def downcase_email
      self.email.downcase!
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = Usuario.new_token
      self.activation_digest = Usuario.digest(activation_token)
    end
    
    def restore_activation_digest
      self.activation_token  = Usuario.new_token
      update_columns(activation_digest: Usuario.digest(activation_token))
    end
  
end
