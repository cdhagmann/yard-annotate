require 'set'

module YarnAnnotate
  class Var
    attr_reader :name
    attr_accessor :types

    def initialize(name, types = TypeSet.new)
      @name = name
      @types = types
    end

    def to_sig
      "#{name}: #{types.to_sig}"
    end
  end
end
