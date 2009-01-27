require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../lib/namecheap'
require 'mocha'

describe "NamecheapAPI Wrapper"  do
  describe "initializating settings" do
    describe "with defaults" do 
      it "shoud contain a username" do
	namecheap = Namecheap.new
	namecheap.send(:username).should == 'apiuser'
      end	  
      it "shoud contain a key"
      it "shoud contain a client_ip"
    end

    describe "with defaults overidden" do 
      it "shoud contain a overidden username" do
	namecheap = Namecheap.new(:username => 'testuser')
	namecheap.send(:username).should == 'testuser'
      end	  

      it "shoud contain a key" do
	namecheap = Namecheap.new(:key => 'testkey')
	namecheap.send(:key).should == 'testkey'
      end
      it "shoud contain a client_ip" do
	namecheap = Namecheap.new(:client_ip => '66.11.22.44')
	namecheap.send(:client_ip).should == '66.11.22.44'
      end
    end
  end

  describe "Attempt to connect with bad credentials" do
    it "should report an error on erroneous account information" do
      namecheap = Namecheap.new
      namecheap.domain_check("fakedomain").status.should == "ERROR"
      end

    it "should give error message for invalid api key when using an invalid key" do
      namecheap = Namecheap.new
      namecheap.domain_check("fakedomain").message.should include("API Key is invalid")
    end
  end

  describe "Attempt to connect with valid credentials" do
     
  end

  describe "#domain_check" do
    it "should build query with multiple domains" do
      namecheap = Namecheap.new()
      namecheap.expects(:do_query).with("namecheap.domains.check", "&DomainList=domain1.com,domain2.com")
      namecheap.domain_check(['domain1.com','domain2.com'])
    end
  end

  describe "#is_domain_available?" do
    it "should return false if connection fails" do
      namecheap = Namecheap.new(:apikey => 'BADKEY')
      lambda {
	namecheap.is_domain_available?('fakedomain.tld').should be_false
      }.should raise_error(NilNamecheapResponse)
    end

    it "should return true if connections succeeds and domain is available" do
      pending "Need API Access To Namecheap.com"
      namecheap = Namecheap.new
      namecheap.is_domain_available?('saucytuborswithashoefetish.com').should be_true
    end

    it "should return false if connections succeeds and domain is not available" do
      namecheap = Namecheap.new
      lambda {
	namecheap.is_domain_available?('hashrocket.com').should be_false
      }.should raise_error(NilNamecheapResponse)
    end
  end
end

