require 'doormat'

# Example implimentation
module Shop
  class Product
    include Doormat

    field :name
    field :id, source: 'SomeID'
    field :price, source: 'ThePrice', type: :float
    field :currency, source: 'Currency', type: :string, default: 'GBP'
    field :reverse_image, source: 'ImageURL', type: :string, default: 'GBP' do |url|
      url.reverse
    end
  end
end


describe Doormat do

  before(:each) do
    @product = Shop::Product.new
    @data = {
      'SomeID'   => '1234',
      'ThePrice' => '450.00',
      'ImageURL' => 'http://example.com/12345-some-text.jpg',
      'name'     => 'kewan'
    }

    @product.parse(@data)
  end

  describe "field" do

    it "maps the field" do
      fields = @product.class.instance_variable_get(:@mapped_fields)
      fields.count.should eq 5
      fields.should have_key(:name)
      fields.should have_key(:id)
      fields.should have_key(:price)
      fields.should have_key(:currency)
      fields.should have_key(:reverse_image)
    end

  end

  describe "parse" do

    it "parses the data with defualt source name being same as to name" do
      @product.name.should eq @data['name']
    end

    it "parses the data to the correct variable" do
      @product.id.should eq @data['SomeID']
    end

    it "parses the data to the correct variable with the correct type" do
      @product.price.should eq @data['ThePrice'].to_f
    end

    it "parses to default if not available in data" do
      @product.currency.should eq 'GBP'
    end

    it "parses using the block to format value" do
      @product.reverse_image.should == @data['ImageURL'].reverse
    end

  end

  describe "to_hash" do

    it "converst mapped fileds to hash" do
      product_hash = @product.to_hash
      product_hash.count.should eq 5
      product_hash[:id].should eq @product.id
      product_hash[:name].should eq @product.name
      product_hash[:price].should eq @product.price
      product_hash[:currency].should eq @product.currency
      product_hash[:reverse_image].should eq @product.reverse_image
    end

  end

end