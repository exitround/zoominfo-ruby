module ZoomInfo
  class Person < ZoomInfo::Base
    SEARCH_NON_KEY_PARAMS = %w(pc numMatches echoInput outputFieldOptions matchCompany uniqueInputId)
    DETAIL_KEY_PARAMS = %w(PersonID EmailAddress)

    def search(query = {})
      query[:key] = generate_key(query.except(*SEARCH_NON_KEY_PARAMS).values, @api_key)
      self.class.get("/person/search", query: query).parsed_response
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
