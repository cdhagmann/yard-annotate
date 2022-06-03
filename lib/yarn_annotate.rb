require 'logger'
require 'parser/current'

module YarnAnnotate
  autoload :ArgList,     'yarn_annotate/arg_list'
  autoload :ArrayType,   'yarn_annotate/array_type'
  autoload :BooleanType, 'yarn_annotate/boolean_type'
  autoload :CLIUtils,    'yarn_annotate/cli_utils'
  autoload :GenericType, 'yarn_annotate/generic_type'
  autoload :HashType,    'yarn_annotate/hash_type'
  autoload :Logger,      'yarn_annotate/logger'
  autoload :MethodDef,   'yarn_annotate/method_def'
  autoload :MethodIndex, 'yarn_annotate/method_index'
  autoload :Namespace,   'yarn_annotate/namespace'
  autoload :NullLogger,  'yarn_annotate/null_logger'
  autoload :Rbi,         'yarn_annotate/rbi'
  autoload :Type,        'yarn_annotate/type'
  autoload :TypeSet,     'yarn_annotate/type_set'
  autoload :Utils,       'yarn_annotate/utils'
  autoload :Var,         'yarn_annotate/var'

  class << self
    attr_accessor :paths
    attr_writer :logger

    def setup
      enable_traces
      index_methods
    end

    def teardown
      disable_traces
    end

    def discover
      setup
      yield
    ensure
      teardown
    end

    def method_index
      @method_index ||= MethodIndex.new
    end

    def paths
      @paths ||= []
    end

    def each_absolute_path(&block)
      Utils.each_absolute_path(paths, &block)
    end

    def register_type(type, handler)
      types[type] = handler
    end

    def types
      @types ||= Hash.new(YarnAnnotate::Type)
    end

    def introspect(obj)
      YarnAnnotate.types[obj.class].introspect(obj)
    end

    def annotate_file(path)
      annotated_code = YarnAnnotate.method_index.annotate(path, File.read(path))
      File.write(path, annotated_code)
    end

    def logger
      @logger ||= ::Logger.new(STDERR)
    end

    private

    def enable_traces
      call_trace.enable
      return_trace.enable
    end

    def disable_traces
      call_trace.disable
      return_trace.disable
    end

    def index_methods
      each_absolute_path.with_index do |path, idx|
        begin
          method_index.index_methods_in(
            path, Parser::CurrentRuby.parse(File.read(path))
          )

          YarnAnnotate::Logger.info("Indexed #{idx + 1}/#{paths.size} paths")
        rescue Parser::SyntaxError => e
          YarnAnnotate::Logger.error("Syntax error in #{path}, skipping")
        end
      end
    end

    def call_trace
      @call_trace ||= TracePoint.new(:call) do |tp|
        if md = method_index.find(tp.path, tp.lineno)
          md.args.each do |arg|
            var = tp.binding.local_variable_get(arg.name)
            arg.types << YarnAnnotate.introspect(var)
          end
        end
      end
    end

    def return_trace
      @return_trace ||= TracePoint.new(:return) do |tp|
        if md = method_index.find(tp.path, tp.lineno)
          md.return_types << YarnAnnotate.introspect(tp.return_value)
        end
      end
    end
  end
end

YarnAnnotate.register_type(::Hash, YarnAnnotate::HashType)
YarnAnnotate.register_type(::Array, YarnAnnotate::ArrayType)
YarnAnnotate.register_type(::TrueClass, YarnAnnotate::BooleanType)
YarnAnnotate.register_type(::FalseClass, YarnAnnotate::BooleanType)
