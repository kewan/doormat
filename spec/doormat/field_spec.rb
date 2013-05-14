require 'doormat/field'

describe Doormat::Field do

  before(:each) do
    @data = {
      'SomeName'   => 'SomeValue',
      'product_id' => '1234',
      'ImageUrl'   => 'http://www.example.com/this.jpg'
    }
  end

  describe "map" do

    it "maps to a field that exists in the supplied data" do
      field = Doormat::Field.new(:name, 'SomeName', :string, "")
      field.map(@data).should == @data['SomeName']
    end

    it "maps to default if not supplied in data" do
      field = Doormat::Field.new(:currency, 'Currency', :string, 'GBP')
      field.map(@data).should == 'GBP'
    end

    it "maps to the supplied type" do
      field = Doormat::Field.new(:id, 'product_id', :integer)
      field.map(@data).should == @data['product_id'].to_i
    end

    it "maps to the suppied field using a block to determine value" do
      field = Doormat::Field.new(:image_url, 'ImageUrl', :string, '') { |url| url.gsub!(/example/, 'monkey') }
      field.map(@data).should == 'http://www.monkey.com/this.jpg'
    end

  end

end