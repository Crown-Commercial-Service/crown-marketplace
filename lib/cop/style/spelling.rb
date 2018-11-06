module RuboCop
  module Cop
    module Style
      class Spelling < Cop
        MSG = 'Misspelt or unknown word (check words.txt)'.freeze

        def check_spelling(text, node)
          return if dictionary.include?(text)

          words = text.reverse.scan(/[a-z]+[A-Z]?|[A-Z]+/)
                      .map(&:reverse)
                      .select { |w| w.length >= 2 }
          return if words.all? { |w| dictionary.include?(w) }

          add_offense(node, location: :expression)
        end

        def on_lvasgn(node)
          lv_symbol = node.children.first
          lv_name = lv_symbol.to_s
          check_spelling lv_name, node
        end

        def on_ivasgn(node)
          iv_symbol = node.children.first
          iv_name = iv_symbol.to_s[1..-1]
          check_spelling iv_name, node
        end

        def on_gvasgn(node)
          gv_symbol = node.children.first
          gv_name = gv_symbol.to_s[1..-1]
          check_spelling gv_name, node
        end

        def on_cvasgn(node)
          cv_symbol = node.children.first
          cv_name = cv_symbol.to_s[2..-1]
          check_spelling cv_name, node
        end

        def on_casgn(node)
          casgn_symbol = node.children[1]
          casgn_name = casgn_symbol.to_s
          check_spelling casgn_name, node
        end

        def on_const(node)
          const_symbol = node.children[1]
          const_name = const_symbol.to_s
          check_spelling const_name, node
        end

        def dictionary
          @dictionary ||= Dictionary.new(
            '/usr/share/dict/words',
            File.expand_path('words.txt', __dir__)
          )
        end

        class Dictionary
          def initialize(*paths)
            @known = Set.new
            paths.each do |path|
              @known += File.read(path).downcase.split(/\n/)
            end
          end

          def include?(word)
            @known.include?(word.downcase)
          end
        end
      end
    end
  end
end
