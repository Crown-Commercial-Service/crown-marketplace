module GovUKHelper::Pagination
  def govuk_pagination(pagination_options)
    tag.nav(class: 'govuk-pagination', role: 'navigation', aria: { label: 'results' }) do
      capture do
        concat(govuk_pagination_prev(pagination_options[:previous][:href])) if pagination_options[:previous]
        if pagination_options[:items]
          concat(tag.ul(class: 'govuk-pagination__list') do
            capture do
              pagination_options[:items].each { |item| concat(govuk_pagination_item(item)) }
            end
          end)
        end
        concat(govuk_pagination_next(pagination_options[:next][:href])) if pagination_options[:next]
      end
    end
  end

  def govuk_pagination_item(item)
    if item[:ellipsis]
      tag.li('⋯', class: 'govuk-pagination__item govuk-pagination__item--ellipses')
    else
      tag.li(class: "govuk-pagination__item #{'govuk-pagination__item--current' if item[:current]}") do
        aria = { label: "Page #{item[:number]}" }
        aria[:current] = 'page' if item[:current]

        link_to(item[:number], item[:href], class: 'govuk-link govuk-pagination__link', aria: aria)
      end
    end
  end

  def govuk_pagination_item_form(form, item)
    tag.li(class: "govuk-pagination__item #{'govuk-pagination__item--current' if item[:current]}") do
      aria = { label: "Page #{item[:number]}" }
      aria[:current] = 'page' if item[:current]

      form.button(item[:number], class: 'govuk-link govuk-pagination__link pagination-number--button_as_link', aria: aria, name: "paginate-#{item[:number]}")
    end
  end

  def govuk_pagination_prev(href, text = 'Previous')
    tag.div(class: 'govuk-pagination__prev') do
      link_to(href, class: 'govuk-link govuk-pagination__link', rel: 'prev') do
        govuk_pagination_arrow(text, :prev)
      end
    end
  end

  def govuk_pagination_prev_form(form, current_page, text = 'Previous')
    tag.div(class: 'govuk-pagination__prev') do
      form.button(class: 'govuk-link govuk-pagination__link pagination--button_as_link', rel: 'prev', name: "paginate-#{current_page - 1}") do
        govuk_pagination_arrow(text, :prev)
      end
    end
  end

  def govuk_pagination_next(href, text = 'Next')
    tag.div(class: 'govuk-pagination__next') do
      link_to(href, class: 'govuk-link govuk-pagination__link', rel: 'next') do
        govuk_pagination_arrow(text, :next)
      end
    end
  end

  def govuk_pagination_next_form(form, current_page, text = 'Next')
    tag.div(class: 'govuk-pagination__next') do
      form.button(class: 'govuk-link govuk-pagination__link pagination--button_as_link', rel: 'next', name: "paginate-#{current_page + 1}") do
        govuk_pagination_arrow(text, :next)
      end
    end
  end

  private

  def govuk_pagination_arrow(text, direction)
    capture do
      concat(tag.span(text, class: 'govuk-pagination__link-title')) if direction == :next
      concat(tag.svg(
        class: "govuk-pagination__icon govuk-pagination__icon--#{direction}",
        xmlns: 'http://www.w3.org/2000/svg',
        height: '13',
        width: '15',
        aria: { hidden: 'true' },
        focusable: 'false',
        viewBox: '0 0 15 13'
      ) do
        tag.path('', d: PAGINATION_ARROW_PATH[direction])
      end)
      concat(tag.span(text, class: 'govuk-pagination__link-title')) if direction == :prev
    end
  end

  PAGINATION_ARROW_PATH = {
    prev: 'm6.5938-0.0078125-6.7266 6.7266 6.7441 6.4062 1.377-1.449-4.1856-3.9768h12.896v-2h-12.984l4.2931-4.293-1.414-1.414z',
    next: 'm8.107-0.0078125-1.4136 1.414 4.2926 4.293h-12.986v2h12.896l-4.1855 3.9766 1.377 1.4492 6.7441-6.4062-6.7246-6.7266z'
  }.freeze
end
