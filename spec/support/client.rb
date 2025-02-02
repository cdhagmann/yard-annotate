require 'sorbet-runtime'

module YarnAnnotateSpecs
  class Response
    attr_reader :status, :body

    def initialize(status, body)
      @status = status
      @body = body
    end

    def to_a
      [status, body]
    end
  end

  class Client
    attr_reader :url, :username

    def initialize(options = {})
      @url = options[:url]
      @username = options[:username]
    end

    def request(body, headers = {})
      Response.new(200, 'it worked!')
    end
  end

  class Utility
    def self.safe_to_string(input)
      if input.nil?
        ''
      else
        input.to_s
      end
    end

    def self.safe_get_keys(input)
      if input.nil?
        []
      else
        input.keys
      end
    end
  end
end

YarnAnnotate.paths << __FILE__
