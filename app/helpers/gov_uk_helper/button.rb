module GovUKHelper::Button
  def govuk_button_start(start_text, link_url, **options)
    class_list = ['govuk-button govuk-button--start']
    class_list << options.delete(:class)

    link_to(link_url, role: 'button', class: class_list, **options) do
      capture do
        concat(start_text)
        concat(tag.svg(class: 'govuk-button__start-icon', xmlns: 'http://www.w3.org/2000/svg', width: 17.5, height: 19, viewBox: '0 0 33 40', aria: { hidden: true }, focusable: false) do
          tag.path(fill: 'currentColor', d: 'M0 0h13l20 20-20 20H0l20-20z')
        end)
      end
    end
  end
end
