module ZoomInfo
  class Base
    include HTTParty
    base_uri 'partnerapi.zoominfo.com/partnerapi/'
    format :xml
    attr_accessor :partner_name, :api_key

    def initialize(partner_name = ENV['ZOOMINFO_CLIENT_ID'], api_key = ENV['ZOOMINFO_KEY'])
      @partner_name = partner_name
      @api_key = api_key
      self.class.default_params({pc: partner_name, outputType: 'xml'})
    end

    def generate_key(search_terms, password)
      search_term_prefaces = search_terms.collect{|t| t[0..1]}.join()
      date_formatted = Time.now.strftime("%-d%-m%-Y")

      Digest::MD5.hexdigest(search_term_prefaces + password + date_formatted)
    end
  end

end
