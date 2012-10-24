require 'spec_helper'

describe PayPal::SDK::Core::API::DataTypes::Base do
  
  DataType = PayPal::SDK::Core::API::DataTypes::Base
  
  class TestCurrency < DataType

    # Members
    object_of :amount, String
    object_of :type,   String, :namespace => "ns"
    # Attributes
    add_attribute :code
  end
  
  class TestType < DataType
    object_of :fromCurrency, TestCurrency
    array_of  :toCurrency,   TestCurrency
  end

  it "should convert the given data to configured type" do
    test_type = TestType.new( :fromCurrency => { :code => "USD", :amount => "50.0"})
    test_type.fromCurrency.should be_a TestCurrency
    test_type.fromCurrency.code.should    eql "USD"
    test_type.fromCurrency.amount.should  eql "50.0"    
  end

  it "should assign value to attribute" do
    test_currency = TestCurrency.new( :@code => "USD", :amount => "50" )
    test_currency.code.should eql "USD"
  end
  
  it "should allow configured Class object" do
    test_currency = TestCurrency.new( :code => "USD", :amount => "50" )
    test_type = TestType.new( :fromCurrency => test_currency )
    test_type.fromCurrency.should eql test_currency
  end
  
  it "should allow snakecase" do
    test_type = TestType.new( :from_currency => {} )
    test_type.from_currency.should be_a TestCurrency
    test_type.from_currency.should eql test_type.fromCurrency
  end
  
  it "should allow array" do
    test_type = TestType.new( :toCurrency => [{ :code => "USD", :amount => "50.0" }] )
    test_type.toCurrency.should be_a Array
    test_type.toCurrency.first.should be_a TestCurrency
  end
  
  it "should allow only configured fields" do
    lambda do
      TestType.new( :notExist => "testing")
    end.should raise_error
  end
  
  it "should convert to hash" do
    test_currency = TestCurrency.new(:amount => "500")
    test_currency.to_hash.should eql(:amount => "500") 
  end

  it "should convert to hash with namespace" do
    test_currency = TestCurrency.new(:amount => "500", :type => "USD" )
    hash = test_currency.to_hash
    hash[:amount].should eql "500"
    hash[:"ns:type"].should eql "USD"
  end

  it "should allow namespace" do
    test_currency = TestCurrency.new(:amount => "500", :"ns:type" => "USD" )
    test_currency.type.should eql "USD"
  end

end

