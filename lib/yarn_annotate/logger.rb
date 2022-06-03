module YarnAnnotate
  module Logger
    class << self
      def debug(str)
        YarnAnnotate.logger.debug(fmt(str))
      end

      def info(str)
        YarnAnnotate.logger.info(fmt(str))
      end

      def warn(str)
        YarnAnnotate.logger.warn(fmt(str))
      end

      def error(str)
        YarnAnnotate.logger.error(fmt(str))
      end

      def fatal(str)
        YarnAnnotate.logger.fatal(fmt(str))
      end

      private

      def fmt(str)
        "[YarnAnnotate] #{str}"
      end
    end
  end
end
