require "test_helper"
require "pry"

describe Merchant do
  let(:merchant) { merchants(:merchant_1) }

  it "must be valid" do
    expect(merchant.valid?).must_equal true
  end

  describe "validations" do
    it "will not be valid if missing username" do
      merchant.username = nil
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.include?(:username)).must_equal true
      expect(merchant.errors[:username]).must_equal ["can't be blank"]
    end

    it "will not be valid if username is not unique" do
      merchant_dup = Merchant.new(username: merchant.username,
                                  email: "duplicate@adda.com",
                                  uid: "4527",
                                  provider: "github")
      expect(merchant_dup.valid?).must_equal false
      expect(merchant_dup.errors.include?(:username)).must_equal true
      expect(merchant_dup.errors[:username]).must_equal ["has already been taken"]
    end

    it "will not be valid if missing email" do
      merchant.email = nil
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.include?(:email)).must_equal true
      expect(merchant.errors[:email]).must_equal ["can't be blank"]
    end

    it "will not be valid if email is not unique" do
      merchant_dup = Merchant.new(username: "gilfoyle",
                                  email: merchant.email,
                                  uid: "4527",
                                  provider: "github")
      expect(merchant_dup.valid?).must_equal false
      expect(merchant_dup.errors.include?(:email)).must_equal true
      expect(merchant_dup.errors[:email]).must_equal ["has already been taken"]
    end

    it "will not be valid if missing uid" do
      merchant.uid = nil
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.include?(:uid)).must_equal true
      expect(merchant.errors[:uid]).must_equal ["can't be blank"]
    end

    it "will not be valid if missing provider" do
      merchant.provider = nil
      expect(merchant.valid?).must_equal false
      expect(merchant.errors.include?(:provider)).must_equal true
      expect(merchant.errors[:provider]).must_equal ["can't be blank"]
    end
  end

  describe "relationship with product" do
    it "can have 0 products" do
      merchant.products.destroy_all
      expect(merchant.products.count).must_equal 0
    end

    it "can have 1 or more products" do
      merchant = merchants(:merchant_2)
      expect(merchant.products.count).must_equal 2
    end

    it "can shovel product to create relationship" do
      product = Product.new(name: "penny", price: 1200, stock: 4)
      expect(product.valid?).must_equal false
      merchant.products << product
      expect(product.valid?).must_equal true
      expect(merchant.products.include?(product)).must_equal true
    end
  end

  describe "custom method build_from_github" do
    it "build auth hash" do
      # this_merchant = merchants(:merchant_1)

      new_auth_hash = {
        provider: "github",
        uid: "543",
        info: {
          email: "jackie@me.net",
          nickname: "EllesMom",
        },
      }
      # binding.pry
      new_merch = Merchant.build_from_github(new_auth_hash)

      new_merch.provider.must_equal "github"
      new_merch.uid.must_equal new_auth_hash[:uid]
      new_merch.email.must_equal new_auth_hash[:info][:email]
      new_merch.username.must_equal new_auth_hash[:info][:nickname]
    end
  end
end
