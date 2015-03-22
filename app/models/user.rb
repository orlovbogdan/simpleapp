class User < ActiveRecord::Base
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, :class_name => 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user




  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation

  before_create :set_invitation_limit

  validates_presence_of :invitation_id, :message => 'is required'
  validates_uniqueness_of :invitation_id





  has_many :pages

  #has_secure_password(validation: false)

  attr_accessor :password
  before_save :encrypt_password

  validates_presence_of :password, :on => :create, unless: :guest?
  validates_presence_of :email, unless: :guest?
  validates_uniqueness_of :email, unless: :guest?
  validates_presence_of :email, unless: :guest?
  validates_confirmation_of :password, unless: :guest?

  #require 'bcrypt'
  #attr_reader :password
  #include ActiveModel::SecurePassword::InstanceMethodsOnActivation



  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  before_create { generate_token(:auth_token) }

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end


  def self.new_guest
    new { |u| u.guest = true }
  end

  def name
    guest ? "Guest" : email
  end

  def move_to(user)
    #tasks.update_all(user_id: user.id)
  end

  def admin?
    try(:admin)
  end


  def invitation_token
    invitation.token if invitation
  end

  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end


  def self.search(search)
    if search
      where('email LIKE ?', "%#{search}%")
    else
      all #scoped
    end
  end

  private

  def set_invitation_limit
    self.invitation_limit = 5
  end




end
