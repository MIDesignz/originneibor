class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include Gravtastic
  gravtastic

  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
          :omniauth_providers => [ :facebook ]

  has_attached_file   :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/original/missing.png",
                      :storage => :s3,
                      :bucket => "unitedneighbor",
                      :s3_region => "us-east-1",
                      :s3_credentials => {
                        :access_key_id => "AKIAJQW4PKQ5F57NJNIQ",
                        :secret_access_key => "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"
                      } 
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/


  has_many :campaigns, :dependent => :delete_all
  has_many :contributions, :dependent => :delete_all
  has_many :notifications, :dependent => :delete_all

  geocoded_by :provided_address  # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode  # auto-fetch addressr

  scope :active_users, -> { where(banned: false) }
  scope :banned_users, -> { where(banned: true) }

  def coordinates
    [latitude, longitude]
  end

  def provided_address
    if address.blank?
      ip_address
    else
      address
    end
  end

  def has_connected_wepay?
    self.wepay_account_status?
  end

  def new_notifications
    notifications.where(read_at: nil).order(created_at: :desc)
  end

  def is_admin?
    self.roles.include?('admin')
  end

  def self.from_omniauth(auth)
    searched_user = where(provider: auth.provider, uid: auth.uid).first
    if searched_user.blank?
      searched_user.create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name
        user.image = auth.info.image
      end
    else
      searched_user.update(email: auth.info.email, name:auth.info.name, image:auth.info.image)
    end
    searched_user
  end
  def update_without_password(params, *options)

      if params[:password].blank?
        params.delete(:password)
        params.delete(:password_confirmation) if params[:password_confirmation].blank?
      end

      result = update_attributes(params, *options)
      clean_up_passwords
      result
    end
end
