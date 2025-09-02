class Search < ApplicationRecord
  belongs_to :user, inverse_of: :searches
  belongs_to :framework, inverse_of: :searches

  serialize :search_criteria, type: Hash, coder: YAML
  serialize :search_result, type: Array, coder: YAML

  def self.log_new_search(framework, user, session_id, search_criteria, search_result)
    return false if find_by(framework_id: framework.id, user_id: user.id, session_id: session_id, search_criteria: search_criteria)

    create!(
      framework_id: framework.id,
      user_id: user.id,
      session_id: session_id,
      search_criteria: search_criteria,
      search_result: search_result.map { |supplier_framework| [supplier_framework.supplier.name, supplier_framework.supplier.id] }
    )
  end
end
