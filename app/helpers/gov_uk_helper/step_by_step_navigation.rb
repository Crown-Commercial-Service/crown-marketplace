module GovUKHelper::StepByStepNavigation
  def govuk_step_by_step_navigation(step_by_step_items)
    generator = Generator.new(step_by_step_items)

    generator.render_html
  end

  class Generator
    include ActionView::Helpers
    include ActionView::Context

    def initialize(step_by_step_items)
      @step_by_step_items = step_by_step_items
      @step_index = 0
    end

    def render_html
      generate_stpe_by_step_navigation
    end

    private

    def generate_stpe_by_step_navigation
      tag.div(id: 'step-by-step-navigation', class: 'gem-c-step-nav gem-c-step-nav--large gem-c-step-nav--active', data: { 'show-text': 'Show', 'hide-text': 'Hide', 'show-all-text': 'Show all', 'hide-all-text': 'Hide all' }) do
        tag.ol(class: 'gem-c-step-nav__steps') do
          capture do
            @step_by_step_items.each do |step_by_step_item|
              @step_index += 1
              section_id = convert_to_id(step_by_step_item[:title])

              concat(tag.li(class: 'gem-c-step-nav__step js-step', id: section_id) do
                capture do
                  concat(heading(step_by_step_item[:title], step_by_step_item[:logic]))
                  concat(content(section_id, step_by_step_item[:content]))
                end
              end)
            end
          end
        end
      end
    end

    def heading(step_heading, logic)
      tag.div(class: 'gem-c-step-nav__header js-toggle-panel', data: { position: @step_index }) do
        tag.h2(class: 'gem-c-step-nav__title') do
          capture do
            concat(tag.span(class: "gem-c-step-nav__circle gem-c-step-nav__circle--#{logic ? 'logic' : 'number'}") do
              tag.span(class: 'gem-c-step-nav__circle-inner') do
                tag.span(class: 'gem-c-step-nav__circle-background') do
                  capture do
                    concat(tag.span('Step', class: 'govuk-visually-hidden'))
                    concat(logic || @step_index)
                  end
                end
              end
            end)
            concat(tag.span(class: 'js-step-title') do
              tag.span(step_heading, class: 'js-step-title-text')
            end)
          end
        end
      end
    end

    def content(section_id, content)
      tag.div(class: 'gem-c-step-nav__panel js-panel', id: "step-panel-#{section_id}-#{@step_index}") do
        capture do
          content.each do |element|
            concat(
              case element[:type]
              when :paragraph
                paragraph(element[:text])
              when :list
                list(element[:items])
              end
            )
          end
        end
      end
    end

    def paragraph(text)
      tag.p(
        text,
        class: 'gem-c-step-nav__paragraph',
      )
    end

    def list(items)
      tag.ul(class: 'gem-c-step-nav__list gem-c-step-nav__list--choice', data: { length: items.length }) do
        capture do
          items.each do |item|
            concat(list_item(item[:text], item[:no_marker]))
          end
        end
      end
    end

    def list_item(text, no_marker)
      tag.li(class: "gem-c-step-nav__list-item js-list-item #{'gem-c-step-nav__list--no-marker' if no_marker}") do
        tag.span(text)
      end
    end

    def convert_to_id(title)
      title.downcase.gsub(' ', '-').gsub('(', '').gsub(')', '')
    end
  end
end
