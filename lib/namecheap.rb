require 'httparty'

class NilNamecheapResponse < Exception
end

class NamecheapResponse
  def initialize(response)
    @response = response
  end

  def status
    @response["ApiResponse"]["Status"] 
  end

  def message
    if @response["ApiResponse"]["Errors"].any?
      @response["ApiResponse"]["Errors"]["Error"]
    end
  end

  def items
    response = @response["ApiResponse"]["CommandResponse"]
    raise NilNamecheapResponse if response.nil?
    response.delete_if { |key, value| key == "Type" }
  end

end

class DomainCheck
  attr_accessor :domain, :available, :error, :description

  def initialize(item)
    @domain = item["Domain"]
    @available = (item["Available"] == "true" ? true : false)
    @error = item["ErrorNo"]
    @description = item["Description"]
  end
end

class NamecheapDomainCheckResponse < NamecheapResponse
  def items
    super.collect {|item| DomainCheck.new(item[1])} 
  end
end

class Namecheap

  def initialize(options = {})
    @apikey = options[:apikey] || "MYKEY"
    @apiuser = options[:apiuser] || "jremsikjr"
    @client_ip = options[:client_ip] || "121.22.123.22"
  end

  def is_domain_available?(domain)
    results = domain_check(domain).items
    results.nil? ? false : results.first.available?
  end

  def domain_check(domain)
    domain = domain.join(",") if domain.is_a? Array
    NamecheapDomainCheckResponse.new(do_query("namecheap.domains.check", "&DomainList=#{domain}"))
  end

  protected
  
  def do_query(api_method, options)
    query = "https://api.sandbox.namecheap.com/xml.response?ApiUser=#{@apiuser}&ApiKey=#{@apikey}&UserName=#{@apiuser}&ClientIp=#{@client_ip}&Command=#{api_method}"
    query += options
    HTTParty.get(query)
  end

end
