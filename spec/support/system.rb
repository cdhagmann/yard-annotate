module YarnAnnotateSpecs
  class System
    def self.configure(config)
      @config = config
      nil
    end
  end
end

YarnAnnotate.paths << __FILE__
