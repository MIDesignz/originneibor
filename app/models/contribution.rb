class Contribution < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :user
  validates :donation_amount, presence: true

  def contribution_text
    if donation_type == 0
      "Volunteered #{donation_amount} hours"
    else
      "Donated $#{donation_amount}"
    end
  end

  def self_contribution_text
    text = "#{user.name} "

    if donation_type == 0
      text += "volunteered #{donation_amount} hours to #{campaign.name}"
    else
      text += "donated $#{donation_amount} to #{campaign.name}"
    end
  end
end
