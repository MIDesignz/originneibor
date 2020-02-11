class Campaign < ActiveRecord::Base
  enum status: [:pending, :active, :rejected]

  has_many :contributions
  validates :name, presence: true
  validates :description, :avatar, presence: true

  belongs_to :user
  has_many :notifications

  geocoded_by :address
  after_validation :geocode

  reverse_geocoded_by :latitude, :longitude, :address => :address
  after_validation :reverse_geocode

  has_attached_file   :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/assets/original/missing.png",
                      :storage => :s3,
                      :bucket => "unitedneighbor",
                      :s3_region => "us-east-1",
                      :s3_credentials => {
                        :access_key_id => "AKIAJQW4PKQ5F57NJNIQ",
                        :secret_access_key => "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"
                      } 
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  scope :active_campaigns, -> { where(status: 1) }
  scope :pending_campaigns, -> { where(status: 0, closed_at: nil) }
  scope :featured_campaigns, -> { where(is_featured: true) }

  before_create :set_campaign_status

  attr_accessor :address
  
  def coordinates
    [latitude, longitude]
  end

  def image_url
    "https://" + ENV['AWS_CLOUDFRONT_HOST'] + "/img/campaigns/#{image_filename}"
  end

  def hours_donated
    if contributions.blank?
      0
    else
      contributions.where(donation_type: 0).pluck(:donation_amount).reduce(0, :+)
    end
  end

  def provided_address
    if address.blank?
      ip_address
    else
      address
    end
  end

  def address
    [street_1, street_2, city, state, zipcode].compact.join(', ')
    # [street_1, street_2].compact.join(', ')
  end

  def create_checkout(redirect_uri)
    # calculate app_fee as 10% of produce price
    app_fee = 20 * 0.1

    params = {
      :account_id => "232385258",
      :short_description => "Produce sold by 20",
      :type => :GOODS,
      :currency => 'USD',
      :amount => 20,      
      :fee => {
          :app_fee => app_fee,
          :fee_payer => 'payee'
      },
      :hosted_checkout => {
          :mode  => 'iframe',
          :redirect_uri => redirect_uri
      }
    }
    wepay = WePay::Client.new(GlobalSetting.first.we_pay_client_id, GlobalSetting.first.we_pay_client_secret, true)
    response = wepay.call('/checkout/create', self.user.wepay_access_token, params)

    p ".... #{response.inspect} ...."

    if !response
      raise "Error - no response from WePay"
    elsif response['error']
      raise "Error - " + response["error_description"]
    end

    return response
  end

  def active?
    status == "active"
  end

  def pending?
    status == "pending"
  end

  def rejected?
    status == "rejected"
  end

  def set_campaign_status
    if GlobalSetting.first.campaigns_require_approval?
      self.status = 0
    else
      self.status = 1
    end
  end
end
