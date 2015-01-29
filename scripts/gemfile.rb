module Gemfile
  class File
    attr_accessor :content
    attr_reader :refinement_rules
    private :content, :content=, :refinement_rules

    GEMFILE_PATH = './Gemfile'

    def initialize(refinement_rules=[])
      @content = read_gemfile
      @refinement_rules = refinement_rules
    end

    def refine
      if refinement_rules.any?
        content = refinement_rules.inject(content) { |content, rule| content = rule.new(content).refine }
        save
      end
    end

  private

    def read_gemfile
      GemfileObjectModel.new( File.read(GEMFILE_PATH) ).parse!
    end

    def save
      File.write("#{GEMFILE_PATH}.test", content.deparse)
    end
  end

  class GemfileObjectModel
    attr_reader :content
    private :content

    def initialize(content)
      @content = content
    end

    def parse!
      @lines = content.each_line.map { |line| Line::Which.new(line) }.map do |line|
        case true
        when line.gem?
          Line::Gem
        when line.comment?
          Line::Comment
        when line.group?
          Line::Group
        when line.empty?
          Line::Empty
        when line.source?
          Line::Source
        when line.end_statement?
          Line::EndStatement
        else
          Line::Null
        end.new(line.string).build!
      end
      self
    end

    def deparse
      # TODO:
    end

    def gem(gem_name)
      # TODO:
    end

    module Line
      class Gem
        attr_reader :string
        private :string

        def initialize(string)
          @string = string
        end

        def build
          @prefix_spaces = string.match(/^(.*)gem.*/)[1]
          quotes = "('|\")"
          @gem_name = string.match(/.*gem\s+#{quotes}(.*?)#{quotes}/)[2]
<<<<<<
          @attributes
          @postfix_content
        end
      end

      class Comment
        def initialize(string)
          @string = string
        end
      end

      class Group
        def initialize(string)
          @string = string
        end
      end

      class Empty
        def initialize(string)
          @string = string
        end
      end

      class Source
        def initialize(string)
          @string = string
        end
      end

      class EndStatement
        def initialize(string)
          @string = string
        end
      end

      class Null
        def initialize(string)
          @string = string
        end
      end
    end

    class Gem
      def initialize(args)
        # TODO:
      end

      def version
        # TODO:
      end

      class Version
        def initialize(args)
          # TODO:
        end
        
        def remove
          # TODO:
        end
      end
    end
  end

  class RefinementRulesBuilder
    RULE_CLASSES = [ Rule::TheRubyRacer ]

    def self.build
      RULE_CLASSES.map { |klass| klass if apply?(klass) }.compact
    end

    def self.apply?(klass)
      true
    end
  end

  module Rule
    class TheRubyRacer
      attr_reader :content
      private :content

      def initialize(content)
        @content = content
      end

      def refine
        content.gem('therubyracer').version.remove
      end
    end
  end
end

Gemfile::File.new( Gemfile::RefinementRulesBuilder.build ).refine
