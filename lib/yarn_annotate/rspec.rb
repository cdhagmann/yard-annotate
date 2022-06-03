require 'yarn-annotate'

RSpec.configure do |config|
  config.before(:suite) do
    YarnAnnotate.paths += ENV.fetch('YARN_ANNOTATE_FILES', '').split(/[\s\n,]/).map(&:strip)
    YarnAnnotate.setup
  end

  config.after(:suite) do
    YarnAnnotate.teardown

    if ENV['YARN_ANNOTATE_ANNOTATE'] == 'true'
      YarnAnnotate.each_absolute_path do |path|
        YarnAnnotate.annotate_file(path)
        YarnAnnotate::Logger.info("Annotated #{path}")
      end
    end

    if ENV['YARN_ANNOTATE_RBI']
      rbi_str = YarnAnnotate::Rbi.new(YarnAnnotate.method_index).to_s

      if ENV['YARN_ANNOTATE_RBI'] == '-'
        puts rbi_str
      else
        File.write(ENV['YARN_ANNOTATE_RBI'], rbi_str)
      end
    end
  end
end
