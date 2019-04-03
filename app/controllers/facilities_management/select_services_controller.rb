# rubocop:disable Metrics/MethodLength
require 'json'
class FacilitiesManagement::SelectServicesController < ApplicationController
  require_permission :facilities_management, only: %i[select_services].freeze

  def select_services
    # Inline error text for this page
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'You must select at least one service before clicking the save continue button'
    # data needs replacing with api or service
    @services = JSON.parse('[
       {
           "code": "C",
           "name": "Maintenance services"
       },
       {
           "code": "D",
           "name": "Horticultural services"
       },
       {
           "code": "E",
           "name": "Statutory obligations"
       },
       {
           "code": "F",
           "name": "Catering services"
       },
       {
           "code": "G",
           "name": "Cleaning services"
       },
       {
           "code": "H",
           "name": "Workplace FM services"
       },
       {
           "code": "I",
           "name": "Reception services"
       },
       {
           "code": "J",
           "name": "Security services"
       },
       {
           "code": "K",
           "name": "Waste services"
       },
       {
           "code": "L",
           "name": "Miscellaneous FM services"
       },
       {
           "code": "M",
           "name": "Computer-aided facilities management (CAFM)"
       },
       {
           "code": "N",
           "name": "Helpdesk services"
       },
       {
           "code": "O",
           "name": "Management of billable works"
       }
   ]')

    @work_packages = JSON.parse('[
        {
            "code": "A.7",
            "name": "Accessibility services",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.12",
            "name": "Business continuity and disaster recovery (“BCDR”) plans",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.9",
            "name": "Customer satisfaction",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.5",
            "name": "Fire safety",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.2",
            "name": "Health and safety",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.1",
            "name": "Integration",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.3",
            "name": "Management services",
            "work_package_code": "A",
            "mandatory": false
        },
        {
            "code": "A.11",
            "name": "Performance self-monitoring",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.6",
            "name": "Permit to work",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.16",
            "name": "Property information mapping service (EPIMS)",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.13",
            "name": "Quality management system",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.10",
            "name": "Reporting",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.8",
            "name": "Risk management",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.15",
            "name": "Selection and management of sub-contractors",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.4",
            "name": "Service delivery plans",
            "work_package_code": "A",
            "mandatory": false
        },
        {
            "code": "A.18",
            "name": "Social value",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.14",
            "name": "Staff and training",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "A.17",
            "name": "Sustainability",
            "work_package_code": "A",
            "mandatory": true
        },
        {
            "code": "B.1",
            "name": "Contract mobilisation",
            "work_package_code": "B",
            "mandatory": true
        },
        {
            "code": "C.21",
            "name": "Airport and aerodrome maintenance services",
            "work_package_code": "C",
            "mandatory": false
        },
        {
            "code": "C.15",
            "name": "Audio visual (AV) equipment maintenance",
            "work_package_code": "C",
            "mandatory": false
        },
        {
            "code": "C.10",
            "name": "Automated barrier control system maintenance",
            "work_package_code": "C",
            "mandatory": false
        },
        {
            "code": "C.11",
            "name": "Building management system (BMS) maintenance",
            "work_package_code": "C",
            "mandatory": true
        },
        {
            "code": "C.14",
            "name": "Catering equipment maintenance",
            "work_package_code": "C",
            "mandatory": true
        },
        {
            "code": "C.3",
            "name": "Environmental cleaning service",
            "work_package_code": "C",
            "mandatory": true
        },
        {
            "code": "C.4",
            "name": "Fire detection and firefighting systems maintenance",
            "work_package_code": "C",
            "mandatory": true
        },
        {
            "code": "C.13",
            "name": "High voltage (HV) and switchgear maintenance",
            "work_package_code": "C",
            "mandatory": true
        },
        {
            "code": "C.7",
            "name": "Internal & external building fabric maintenance",
            "work_package_code": "C",
            "mandatory": true
        },
        {
            "code": "C.5",
            "name": "Lifts, hoists & conveyance systems maintenance",
            "work_package_code": "C",
            "mandatory": true
        },
        {
            "code": "C.20",
            "name": "Locksmith services",
            "work_package_code": "C",
            "mandatory": false
        },
        {
            "code": "C.17",
            "name": "Mail room equipment maintenance",
            "work_package_code": "C",
            "mandatory": false
        },
        {
            "code": "C.1",
            "name": "Mechanical and electrical engineering maintenance",
            "work_package_code": "C",
            "mandatory": true
        },
        {
            "code": "C.18",
            "name": "Office machinery servicing and maintenance",
            "work_package_code": "C",
            "mandatory": false
        },
        {
            "code": "C.9",
            "name": "Planned / group re-lamping service",
            "work_package_code": "C",
            "mandatory": false
        },
        {
            "code": "C.8",
            "name": "Reactive maintenance services",
            "work_package_code": "C",
            "mandatory": true
        },
        {
            "code": "C.6",
            "name": "Security, access and intruder systems maintenance",
            "work_package_code": "C",
            "mandatory": true
        },
        {
            "code": "C.22",
            "name": "Specialist maintenance services",
            "work_package_code": "C",
            "mandatory": false
        },
        {
            "code": "C.12",
            "name": "Standby power system maintenance",
            "work_package_code": "C",
            "mandatory": true
        },
        {
            "code": "C.16",
            "name": "Television cabling maintenance",
            "work_package_code": "C",
            "mandatory": false
        },
        {
            "code": "C.2",
            "name": "Ventilation and air conditioning system maintenance",
            "work_package_code": "C",
            "mandatory": true
        },
        {
            "code": "C.19",
            "name": "Voice announcement system maintenance",
            "work_package_code": "C",
            "mandatory": false
        },
        {
            "code": "D.6",
            "name": "Cut flowers and christmas trees",
            "work_package_code": "D",
            "mandatory": false
        },
        {
            "code": "D.1",
            "name": "Grounds maintenance services",
            "work_package_code": "D",
            "mandatory": false
        },
        {
            "code": "D.5",
            "name": "Internal planting",
            "work_package_code": "D",
            "mandatory": false
        },
        {
            "code": "D.3",
            "name": "Professional snow & ice clearance",
            "work_package_code": "D",
            "mandatory": false
        },
        {
            "code": "D.4",
            "name": "Reservoirs, ponds, river walls and water features maintenance",
            "work_package_code": "D",
            "mandatory": false
        },
        {
            "code": "D.2",
            "name": "Tree surgery (arboriculture)",
            "work_package_code": "D",
            "mandatory": false
        },
        {
            "code": "E.1",
            "name": "Asbestos management",
            "work_package_code": "E",
            "mandatory": true
        },
        {
            "code": "E.9",
            "name": "Building information modelling and government soft landings",
            "work_package_code": "E",
            "mandatory": false
        },
        {
            "code": "E.5",
            "name": "Compliance plans, specialist surveys and audits",
            "work_package_code": "E",
            "mandatory": true
        },
        {
            "code": "E.6",
            "name": "Conditions survey",
            "work_package_code": "E",
            "mandatory": false
        },
        {
            "code": "E.7",
            "name": "Electrical testing",
            "work_package_code": "E",
            "mandatory": true
        },
        {
            "code": "E.8",
            "name": "Fire risk assessments",
            "work_package_code": "E",
            "mandatory": true
        },
        {
            "code": "E.4",
            "name": "Portable appliance testing",
            "work_package_code": "E",
            "mandatory": true
        },
        {
            "code": "E.3",
            "name": "Statutory inspections",
            "work_package_code": "E",
            "mandatory": true
        },
        {
            "code": "E.2",
            "name": "Water hygiene maintenance",
            "work_package_code": "E",
            "mandatory": true
        },
        {
            "code": "F.1",
            "name": "Chilled potable water",
            "work_package_code": "F",
            "mandatory": false
        },
        {
            "code": "F.2",
            "name": "Retail services / convenience store",
            "work_package_code": "F",
            "mandatory": false
        },
        {
            "code": "F.3",
            "name": "Deli/coffee bar",
            "work_package_code": "F",
            "mandatory": false
        },
        {
            "code": "F.4",
            "name": "Events and functions",
            "work_package_code": "F",
            "mandatory": false
        },
        {
            "code": "F.5",
            "name": "Full service restaurant",
            "work_package_code": "F",
            "mandatory": false
        },
        {
            "code": "F.6",
            "name": "Hospitality and meetings",
            "work_package_code": "F",
            "mandatory": false
        },
        {
            "code": "F.7",
            "name": "Outside catering",
            "work_package_code": "F",
            "mandatory": false
        },
        {
            "code": "F.8",
            "name": "Trolley service",
            "work_package_code": "F",
            "mandatory": false
        },
        {
            "code": "F.9",
            "name": "Vending services (food & beverage)",
            "work_package_code": "F",
            "mandatory": false
        },
        {
            "code": "F.10",
            "name": "Residential catering services",
            "work_package_code": "F",
            "mandatory": false
        },
        {
            "code": "G.8",
            "name": "Cleaning of communications and equipment rooms",
            "work_package_code": "G",
            "mandatory": false
        },
        {
            "code": "G.13",
            "name": "Cleaning of curtains and window blinds",
            "work_package_code": "G",
            "mandatory": false
        },
        {
            "code": "G.5",
            "name": "Cleaning of external areas",
            "work_package_code": "G",
            "mandatory": true
        },
        {
            "code": "G.2",
            "name": "Cleaning of integral barrier mats",
            "work_package_code": "G",
            "mandatory": true
        },
        {
            "code": "G.4",
            "name": "Deep (periodic) cleaning",
            "work_package_code": "G",
            "mandatory": true
        },
        {
            "code": "G.10",
            "name": "Housekeeping",
            "work_package_code": "G",
            "mandatory": false
        },
        {
            "code": "G.11",
            "name": "It equipment cleaning",
            "work_package_code": "G",
            "mandatory": false
        },
        {
            "code": "G.16",
            "name": "Linen and laundry services",
            "work_package_code": "G",
            "mandatory": false
        },
        {
            "code": "G.14",
            "name": "Medical and clinical cleaning",
            "work_package_code": "G",
            "mandatory": false
        },
        {
            "code": "G.3",
            "name": "Mobile cleaning services",
            "work_package_code": "G",
            "mandatory": true
        },
        {
            "code": "G.15",
            "name": "Pest control services",
            "work_package_code": "G",
            "mandatory": true
        },
        {
            "code": "G.9",
            "name": "Reactive cleaning (outside cleaning operational hours)",
            "work_package_code": "G",
            "mandatory": true
        },
        {
            "code": "G.1",
            "name": "Routine cleaning",
            "work_package_code": "G",
            "mandatory": true
        },
        {
            "code": "G.12",
            "name": "Specialist cleaning",
            "work_package_code": "G",
            "mandatory": false
        },
        {
            "code": "G.7",
            "name": "Window cleaning (external)",
            "work_package_code": "G",
            "mandatory": true
        },
        {
            "code": "G.6",
            "name": "Window cleaning (internal)",
            "work_package_code": "G",
            "mandatory": true
        },
        {
            "code": "H.16",
            "name": "Administrative support services",
            "work_package_code": "H",
            "mandatory": false
        },
        {
            "code": "H.9",
            "name": "Archiving (on-site)",
            "work_package_code": "H",
            "mandatory": false
        },
        {
            "code": "H.12",
            "name": "Cable management",
            "work_package_code": "H",
            "mandatory": false
        },
        {
            "code": "H.7",
            "name": "Clocks",
            "work_package_code": "H",
            "mandatory": true
        },
        {
            "code": "H.3",
            "name": "Courier booking and external distribution",
            "work_package_code": "H",
            "mandatory": true
        },
        {
            "code": "H.10",
            "name": "Furniture management",
            "work_package_code": "H",
            "mandatory": false
        },
        {
            "code": "H.4",
            "name": "Handyman services",
            "work_package_code": "H",
            "mandatory": true
        },
        {
            "code": "H.2",
            "name": "Internal messenger service",
            "work_package_code": "H",
            "mandatory": true
        },
        {
            "code": "H.1",
            "name": "Mail services",
            "work_package_code": "H",
            "mandatory": true
        },
        {
            "code": "H.5",
            "name": "Move and space management - internal moves",
            "work_package_code": "H",
            "mandatory": true
        },
        {
            "code": "H.15",
            "name": "Portable washroom solutions",
            "work_package_code": "H",
            "mandatory": false
        },
        {
            "code": "H.6",
            "name": "Porterage",
            "work_package_code": "H",
            "mandatory": true
        },
        {
            "code": "H.13",
            "name": "Reprographics service",
            "work_package_code": "H",
            "mandatory": false
        },
        {
            "code": "H.8",
            "name": "Signage",
            "work_package_code": "H",
            "mandatory": true
        },
        {
            "code": "H.11",
            "name": "Space management",
            "work_package_code": "H",
            "mandatory": false
        },
        {
            "code": "H.14",
            "name": "Stores management",
            "work_package_code": "H",
            "mandatory": false
        },
        {
            "code": "I.3",
            "name": "Car park management and booking",
            "work_package_code": "I",
            "mandatory": true
        },
        {
            "code": "I.1",
            "name": "Reception service",
            "work_package_code": "I",
            "mandatory": true
        },
        {
            "code": "I.2",
            "name": "Taxi booking service",
            "work_package_code": "I",
            "mandatory": true
        },
        {
            "code": "I.4",
            "name": "Voice announcement system operation",
            "work_package_code": "I",
            "mandatory": true
        },
        {
            "code": "J.8",
            "name": "Additional security services",
            "work_package_code": "J",
            "mandatory": false
        },
        {
            "code": "J.2",
            "name": "Cctv / alarm monitoring",
            "work_package_code": "J",
            "mandatory": true
        },
        {
            "code": "J.3",
            "name": "Control of access and security passes",
            "work_package_code": "J",
            "mandatory": true
        },
        {
            "code": "J.4",
            "name": "Emergency response",
            "work_package_code": "J",
            "mandatory": true
        },
        {
            "code": "J.9",
            "name": "Enhanced security requirements",
            "work_package_code": "J",
            "mandatory": false
        },
        {
            "code": "J.10",
            "name": "Key holding",
            "work_package_code": "J",
            "mandatory": false
        },
        {
            "code": "J.11",
            "name": "Lock up / open up of buyer premises",
            "work_package_code": "J",
            "mandatory": false
        },
        {
            "code": "J.6",
            "name": "Management of visitors and passes",
            "work_package_code": "J",
            "mandatory": true
        },
        {
            "code": "J.1",
            "name": "Manned guarding service",
            "work_package_code": "J",
            "mandatory": true
        },
        {
            "code": "J.5",
            "name": "Patrols (fixed or static guarding)",
            "work_package_code": "J",
            "mandatory": true
        },
        {
            "code": "J.12",
            "name": "Patrols (mobile via a specific visiting vehicle)",
            "work_package_code": "J",
            "mandatory": false
        },
        {
            "code": "J.7",
            "name": "Reactive guarding",
            "work_package_code": "J",
            "mandatory": true
        },
        {
            "code": "K.1",
            "name": "Classified waste",
            "work_package_code": "K",
            "mandatory": true
        },
        {
            "code": "K.5",
            "name": "Clinical waste",
            "work_package_code": "K",
            "mandatory": false
        },
        {
            "code": "K.7",
            "name": "Feminine hygiene waste",
            "work_package_code": "K",
            "mandatory": true
        },
        {
            "code": "K.2",
            "name": "General waste",
            "work_package_code": "K",
            "mandatory": true
        },
        {
            "code": "K.4",
            "name": "Hazardous waste",
            "work_package_code": "K",
            "mandatory": false
        },
        {
            "code": "K.6",
            "name": "Medical waste",
            "work_package_code": "K",
            "mandatory": false
        },
        {
            "code": "K.3",
            "name": "Recycled waste",
            "work_package_code": "K",
            "mandatory": true
        },
        {
            "code": "L.1",
            "name": "Childcare facility",
            "work_package_code": "L",
            "mandatory": false
        },
        {
            "code": "L.2",
            "name": "Sports and leisure",
            "work_package_code": "L",
            "mandatory": false
        },
        {
            "code": "L.3",
            "name": "Driver and vehicle service",
            "work_package_code": "L",
            "mandatory": false
        },
        {
            "code": "L.4",
            "name": "First aid and medical service",
            "work_package_code": "L",
            "mandatory": false
        },
        {
            "code": "L.5",
            "name": "Flag flying service",
            "work_package_code": "L",
            "mandatory": false
        },
        {
            "code": "L.6",
            "name": "Journal, magazine and newspaper supply",
            "work_package_code": "L",
            "mandatory": false
        },
        {
            "code": "L.7",
            "name": "Hairdressing services",
            "work_package_code": "L",
            "mandatory": false
        },
        {
            "code": "L.8",
            "name": "Footwear cobbling services",
            "work_package_code": "L",
            "mandatory": false
        },
        {
            "code": "L.9",
            "name": "Provision of chaplaincy support services",
            "work_package_code": "L",
            "mandatory": false
        },
        {
            "code": "L.10",
            "name": "Housing and residential accommodation management",
            "work_package_code": "L",
            "mandatory": false
        },
        {
            "code": "L.11",
            "name": "Training establishment management and booking service",
            "work_package_code": "L",
            "mandatory": false
        },
        {
            "code": "M.1",
            "name": "CAFM system",
            "work_package_code": "M",
            "mandatory": true
        },
        {
            "code": "N.1",
            "name": "Helpdesk services",
            "work_package_code": "N",
            "mandatory": true
        },
        {
            "code": "O.1",
            "name": "Management of billable works",
            "work_package_code": "O",
            "mandatory": true
        }]', create_additions: true)
  end
end
# rubocop:enable Metrics/MethodLength
