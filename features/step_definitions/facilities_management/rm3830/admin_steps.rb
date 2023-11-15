Given('select {string} for sublot {string} for {string}') do |option, sublot, supplier|
  link_text = if option == 'Services' && sublot == '1a'
                'Services, prices and variances'
              else
                option
              end

  supplier_section = admin_page.find('h2', text: supplier).find(:xpath, '../..')
  sublot_section = supplier_section.find('span', text: "Sub-lot #{sublot}").find(:xpath, '..')
  sublot_section.click_on(link_text)
end
