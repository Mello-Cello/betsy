require "test_helper"

describe Merchant do
  let(:merchant) { merchants(:one) }

  it "must be valid" do
    expect(merchant.valid?).must_equal true
  end

  # validates :username, presence: true, uniqueness: true
  # validates :email, presence: true, uniqueness: true
  # validates :uid, presence: true
  # validates :provider, presence: true

  describe "validations" do
    it "will not be valid if missing username" do
    end

    it "will not be valid if username is not unique" do
    end

    it "will not be valid if missing email" do
    end

    it "will not be valid if email is not unique" do
    end

    it "will not be valid if missing uid" do
    end
    
    it "will not be valid if missing provider" do
    end
  end
end
