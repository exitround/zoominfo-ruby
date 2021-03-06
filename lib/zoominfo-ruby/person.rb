module ZoomInfo
  class Person < ZoomInfo::Base
    SEARCH_NON_KEY_PARAMS = %w(pc outputType outputFieldOptions key rpp page SortBy SortOrder)
    MATCH_NON_KEY_PARAMS = %w(pc key numMatches echoInput outputFieldOptions matchCompany uniqueInputId)
    DETAIL_KEY_PARAMS = %w(PersonID EmailAddress)

    def search(query = {})
      key_values = query.reject{|k, v| SEARCH_NON_KEY_PARAMS.include?(k.to_s)}.values
      query[:key] = generate_key(key_values, @api_key)
      self.class.get("/person/search", query: query).parsed_response
    end

    def match(query = {})
      key_values = query.reject{|k, v| MATCH_NON_KEY_PARAMS.include?(k.to_s)}.values
      query[:key] = generate_key(key_values, @api_key)
      self.class.get("/person/match", query: query).parsed_response
    end

    def detail(query = {})
      query[:key] = generate_key(query.slice(*DETAIL_KEY_PARAMS).values, @api_key)
      self.class.get("/person/detail", query: query).parsed_response
    end

    def search_by_email(email_address)
      search('EmailAddress' => email_address)
    end

    def detail_by_id(person_id)
      detail('PersonID' => person_id)
    end
  end
end
