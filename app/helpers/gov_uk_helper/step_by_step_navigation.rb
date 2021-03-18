module GovUKHelper::StepByStepNavigation
  def govuk_step_by_step_navigation(&block)
    content_tag(:div, id: 'step-by-step-navigation', class: 'app-step-nav app-step-nav--large app-step-nav--active', data: { 'show-text': 'Show', 'hide-text': 'Hide', 'show-all-text': 'Show all', 'hide-all-text': 'Hide all' }) do
      content_tag(:ol, class: 'app-step-nav__steps', &block)
    end
  end

  def govuk_step_by_step_navigation_step(step_heading, position, &block)
    tag.li(class: 'app-step-nav__step js-step', id: "step-panel-#{position}") do
      capture do
        concat(govuk_step_by_step_navigation_heading(step_heading, position))
        concat(govuk_step_by_step_navigation_content(position, &block))
      end
    end
  end

  def govuk_step_by_step_navigation_heading(step_heading, position)
    tag.div(class: 'app-step-nav__header js-toggle-panel', data: { position: position }) do
      tag.h2(class: 'app-step-nav__title') do
        capture do
          concat(tag.span(class: 'app-step-nav__circle app-step-nav__circle--number') do
            tag.span(class: 'app-step-nav__circle-inner') do
              tag.span(class: 'app-step-nav__circle-background') do
                capture do
                  concat(tag.span('Step', class: 'govuk-visually-hidden'))
                  concat(position)
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

  def govuk_step_by_step_navigation_content(position, &block)
    tag.div(class: 'app-step-nav__panel js-panel', id: "step-panel-#{position}-content", &block)
  end

  def govuk_step_by_step_navigation_break(break_text, space_required = false)
    tag.li(class: 'app-step-nav__step') do
      tag.div(class: 'app-step-nav__header') do
        tag.h2(class: 'app-step-nav__title') do
          capture do
            concat(tag.span(class: 'app-step-nav__square app-step-nav__square--logic') do
              tag.span(class: 'pp-step-nav__square-inner') do
                tag.span(break_text, class: 'app-step-nav__square-background')
              end
            end)
            concat(tag.span('&nbsp;'.html_safe, class: 'js-step-title', style: 'margin-left: 0')) if space_required
          end
        end
      end
    end
  end
end
