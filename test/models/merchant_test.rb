require "test_helper"

describe Merchant do
  let(:merchant) { merchants(:one) }

  it "must be valid" do
    expect(merchant.valid?).must_equal true
  end

  describe "validations" do
    it "will not be valid if missing username" do
      merchant.username = nil
      expect(merchant.valid?).must_equal false
    end

    it "will not be valid if username is not unique" do
      merchant_dup = Merchant.new(username: merchant.username,
                                  email: "duplicate@adda.com",
                                  uid: "4527",
                                  provider: "github")
      expect(merchant_dup.valid?).must_equal false
    end

    it "will not be valid if missing email" do
      merchant.email = nil
      expect(merchant.valid?).must_equal false
    end

    it "will not be valid if email is not unique" do
      merchant_dup = Merchant.new(username: "gilfoyle",
                                  email: merchant.email,
                                  uid: "4527",
                                  provider: "github")
      expect(merchant_dup.valid?).must_equal false
    end

    it "will not be valid if missing uid" do
      merchant.uid = nil
      expect(merchant.valid?).must_equal false
    end

    it "will not be valid if missing provider" do
      merchant.provider = nil
      expect(merchant.valid?).must_equal false
    end
  end
end
