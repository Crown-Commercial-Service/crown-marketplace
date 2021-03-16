class Common < SitePrism::Page
  element :next_pagination, 'li.ccs-last > button'
  element :previous_pagination, 'li.ccs-first > button'
end
