module FacilitiesManagement::ProcurementSuppliersHelper
  CONTRACT_STATE = { sent: 'Awaiting supplier response',
                     accepted: 'Awaiting contract signature',
                     not_signed: 'Accepted, not signed',
                     declined: 'Supplier declined',
                     expired: 'No supplier response' }.freeze
end
