require 'sorbet-runtime'

module YarnAnnotateSpecs
  class Request
    extend T::Sig
    sig { params(status: String, body: String).returns(T::Array[String]) }
    def to_a(status, body)
      [status, body]
    end

    def to_s(number)
      number&.to_s
    end
  end
end

YarnAnnotate.paths << __FILE__
