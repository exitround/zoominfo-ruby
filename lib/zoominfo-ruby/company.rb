module ZoomInfo
  class Company < ZoomInfo::Base
    SEARCH_NON_KEY_PARAMS = %w(pc outputType outputFieldOptions rpp page SortBy SortOrder)
    DETAIL_KEY_PARAMS = %w(CompanyID CompanyDomain)

    def search(query = {})
      query[:key] = generate_key(query.except(*SEARCH_NON_KEY_PARAMS).values, @api_key)
      self.class.get("/company/search", query: query).parsed_response
    end

    def detail(query = {})
      query[:key] = generate_key(query.slice(*DETAIL_KEY_PARAMS).values, @api_key)
      self.class.get("/company/detail", query: query).parsed_response["CompanyDetailRequest"]
    end

    def search_by_company_name(company_name)
      search('CompanyName' => company_name)['CompanySearchRequest']['CompanySearchResults']
    end

    def detail_by_domain_name(domain_name, opts = {})
      detail({'CompanyDomain' => domain_name}.merge!(opts))
    end

    # Runs 2 API calls, first to people search, second to company detail
    def company_by_email(email_address)
      company_id = Person.new(@partner_name, @api_key).search_by_email(email_address)['PeopleSearchRequest']['PeopleSearchResults']['CurrentEmployment']['Company']['CompanyID']
      detail('CompanyID' => company_id)
    end

  end
end
