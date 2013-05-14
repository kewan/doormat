require 'doormat'

# Example implimentation
module Shop
  class Product
    include Doormat

    field :id, 'SomeID'
    field :price, 'ThePrice', type: :float
    field :currency, 'Currency', type: :string, default: 'GBP'
    field :reverse_image, 'ImageURL', type: :string, default: 'GBP' do |url|
      url.reverse
    end
  end
end


describe Doormat do

  before(:each) do
    @product = Shop::Product.new
    @data = {
      'SomeID' => '1234',
      'ThePrice' => '450.00',
      'ImageURL' => 'http://example.com/12345-some-text.jpg'
    }

    @product.parse(@data)
  end

  describe "field" do

    it "maps the field" do
      fields = @product.class.instance_variable_get(:@mapped_fields)
      fields.count.should == 4
      fields.has_key?(:id).should == true
      fields.has_key?(:price).should == true
      fields.has_key?(:currency).should == true
      fields.has_key?(:reverse_image).should == true
    end

  end

  describe "parse" do

    it "parses the data to the correct variable" do
      @product.id.should == '1234'
    end

    it "parses the data to the correct variable with the correct type" do
      @product.price.should == 450.0
    end

    it "parses to default if not available in data" do
      @product.currency.should == 'GBP'
    end

    it "parses using the block to format value" do
      @product.reverse_image.should == @data['ImageURL'].reverse
    end

  end

end