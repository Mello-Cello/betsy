class Merchant < ApplicationRecord
  has_many :products

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :uid, presence: true
  validates :provider, presence: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.username = auth_hash[:info][:nickname]
    merchant.email = auth_hash[:info][:email]
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"
    return merchant
  end
end
