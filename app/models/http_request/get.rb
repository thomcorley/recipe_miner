# frozen_string_literal: true
module HttpRequest
  class Get
    def initialize(url:, requester: HTTParty)
      @url = url
      @requester = requester
    end

    def response
      @requester.get(@url)
    end

    def code
      @requester.get(@url).code
    end

    def body
      @requester.get(@url).body
    end
  end
end
