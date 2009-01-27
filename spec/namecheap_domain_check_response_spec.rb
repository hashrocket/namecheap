require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/../lib/namecheap'

describe NamecheapDomainCheckResponse  do
  
  describe "successful response from namecheap" do
    before(:each) do
	@domain_check_response_hash = {"ApiResponse"=>{"Status"=>"OK", 
			      "Errors"=>{},  
			    "CommandResponse" => {"Type" => "namecheap.domains.check", 
			      "DomainCheckResult1" => {"Domain" => "domain1.com", "Available" => "true"},
			      "DomainCheckResult2" => {"Domain" => "domain2.com", "Available" => "false"},
			      "DomainCheckResult3" => {"Domain" => "domain.wtf", "Available" => "error", 
			      "ErrorNo" => "750", "Description" => "No response from the registry"}},
			    "GMTTimeDifference"=>"--6:00", 
			    "RequestedCommand"=>"namecheap.domains.check", 
			    "Server"=>"SERVER159", 
			    "ExecutionTime"=>"0.01", 
			    "xmlns"=>"http://api.namecheap.com/xml.response"}} 

      @response = NamecheapDomainCheckResponse.new(@domain_check_response_hash)

    end

    it "should have a domain check result" do
      @response.items.length.should == 3
    end

    it "should report that domain1.com is available" do
      @response.items[1].available.should be_true
    end

    it "should report that domain2.com is not available" do
      @response.items[2].available.should be_false
    end

    it "should report errors if there are any" do
      @response.items[0].error.should == "750"
    end

    it "should include a description if there are errors" do
      @response.items[0].description == "No response from the registry"
    end
  end

  describe "failure response from namecheap" do 
    before(:each) do
      @bad_response_hash = {"ApiResponse"=>{"Status"=>"ERROR", 
	      "Errors"=>{"Error"=>"API Key is invalid or API access has not been enabled"}, 
	      "GMTTimeDifference"=>"--6:00", 
	      "RequestedCommand"=>"namecheap.domains.check", 
	      "Server"=>"SERVER159", 
	      "ExecutionTime"=>"0.01", 
	      "xmlns"=>"http://api.namecheap.com/xml.response"}}
       

      it "should return false if bad hash is returned" do
        
      end
    end
  end
end

  #<?xml version="1.0" encoding="utf-8"?>
  # <ApiResponse Status="OK" xmlns="http://api.namecheap.com/xml.response">
  #  <Errors />
  #  <RequestedCommand>namecheap.domains.check</RequestedCommand>
  #  <CommandResponse Type="namecheap.domains.check">
  #    <DomainCheckResult Domain="domain1.com" Available="true" />
  #    <DomainCheckResult Domain="availabledomain.com" Available="false" />
  #    <DomainCheckResult Domain="err.tld" Available="error" ErrorNo="750" Description="No response from the registry" />
  #  </CommandResponse>
  #  <Server>SERVER-NAME</Server>
  #  <GMTTimeDifference>+5</GMTTimeDifference>
  #  <ExecutionTime>32.76</ExecutionTime>
  #</ApiResponse>


