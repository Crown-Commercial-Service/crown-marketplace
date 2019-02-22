class FacilitiesManagement::LongListController < ApplicationController
  require_permission :facilities_management, only: :longList
  def longList

    @supplierData = JSON.parse('[
  {
    "supplier_name": "2020 DELIVERY LTD",
    "supplier_id": "19a46e37-d77b-4edc-b8d9-b739e317d6b0",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.5",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.20",
          "1.21",
          "1.19",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Catherine Mulcahy",
    "contact_email": "enquiries@2020delivery.com",
    "contact_phone": "07872 603518"
  },
  {
    "supplier_name": "4C ASSOCIATES LTD",
    "supplier_id": "6b1e7cd8-175a-4299-91a6-14fdd0aa35f6",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.11",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Mark Ellis",
    "contact_email": "info@4cassociates.com",
    "contact_phone": "07725 826261"
  },
  {
    "supplier_name": "4OC LTD",
    "supplier_id": "fd60a4fc-8d11-4420-88ea-c1ccb1fca412",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "James Curran",
    "contact_email": "hello@the4oc.com",
    "contact_phone": "07595 334553"
  },
  {
    "supplier_name": "ABLE & HOW LTD",
    "supplier_id": "b73b92bd-f160-41fa-8c09-c4a72aaa3374",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.8"
        ]
      }
    ]
  },
  {
    "supplier_name": "ACCENTURE (UK) LTD",
    "supplier_id": "1a1e8b90-39f3-4454-96e2-b87ab1ffe1d1",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Simon Mitchell",
    "contact_email": "sales.support.uk@accenture.com"
  },
  {
    "supplier_name": "ACCORDIO LTD",
    "supplier_id": "4884ad9b-3b3d-4cc5-82a3-75b6ef409881",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.15",
          "1.17",
          "1.19",
          "1.24"
        ]
      }
    ],
    "contact_name": "Rob Neil",
    "contact_email": "info@accordio.co.uk",
    "contact_phone": "07802 400407"
  },
  {
    "supplier_name": "ACTICA CONSULTING LTD",
    "supplier_id": "4e0e94e0-5da7-4b1f-8700-39624c2c3058",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.28",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Michael Murphy",
    "contact_email": "opportunities@actica.co.uk",
    "contact_phone": "01483 484090"
  },
  {
    "supplier_name": "ACUITY BUSINESS SOLUTIONS LTD",
    "supplier_id": "436702ac-fad0-4230-848d-7567572e782e",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.4",
          "2.6",
          "2.8",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.17",
          "2.21",
          "2.22",
          "2.26",
          "2.27",
          "2.29",
          "2.31"
        ]
      }
    ],
    "contact_name": "Sarah Thomas",
    "contact_email": "sarah.thomas@acuitynet.co.uk",
    "contact_phone": "01392 826035"
  },
  {
    "supplier_name": "ADAM SMITH INTERNATIONAL LTD",
    "supplier_id": "a5467bbe-1ada-4804-a971-07f04582ab3d",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.5",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.27",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Luqman Ahmad",
    "contact_email": "mcf2@adamsmithinternational.com",
    "contact_phone": "0207 091 3535"
  },
  {
    "supplier_name": "ADVALUS LTD",
    "supplier_id": "63cb1714-fcdd-4c86-a368-fe2f0f1f3664",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Rob Francis",
    "contact_email": "info@advalus.com"
  },
  {
    "supplier_name": "AGILESPHERE CONSULTING (UK) LTD",
    "supplier_id": "79ac54ce-3dfb-4003-b2af-254071f68697",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.8",
          "1.15",
          "1.19"
        ]
      }
    ],
    "contact_name": "Hugh Ivory",
    "contact_email": "proposals@agilesphere.co.uk",
    "contact_phone": "020 3283 8777"
  },
  {
    "supplier_name": "AGILISYS LTD",
    "supplier_id": "ad83f454-b602-4438-8d17-70c9192cdb3c",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Darren London",
    "contact_email": "info@agilisys.co.uk",
    "contact_phone": "07702 367779"
  },
  {
    "supplier_name": "AKESO & COMPANY LTD",
    "supplier_id": "c061f627-c725-49b6-9b87-cf33c73070aa",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Janak Gunatilleke",
    "contact_email": "info@akesoco.com",
    "contact_phone": "020 3011 1381"
  },
  {
    "supplier_name": "ALAMAC LTD",
    "supplier_id": "07fc72de-f5e8-42b4-a582-d1fda4613dc8",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.3",
          "1.8",
          "1.13",
          "1.15"
        ]
      }
    ],
    "contact_name": "Amanda Crane",
    "contact_email": "contactus@alamac.co.uk"
  },
  {
    "supplier_name": "ALBANY BECK CONSULTING SERVICES LTD",
    "supplier_id": "eee51e76-0584-41de-91de-6eb08dc6ef94",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.17",
          "1.19"
        ]
      }
    ],
    "contact_name": "Guthrie Holliday",
    "contact_email": "info@albanybeckcom",
    "contact_phone": "01892 553217"
  },
  {
    "supplier_name": "ALCHEMMY CONSULTING LTD",
    "supplier_id": "cefdf7eb-0a14-454a-af24-680ef7f1609d",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.10",
          "1.11",
          "1.12",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.31"
        ]
      }
    ],
    "contact_name": "Bernie Levins",
    "contact_email": "MCF2@alchemmy.com",
    "contact_phone": "0207 112 8651"
  },
  {
    "supplier_name": "ALERON PARTNERS LTD",
    "supplier_id": "3c85e086-1fc1-44a6-b04f-327e1116c3bb",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Nicolas Ponset",
    "contact_email": "nicolas.ponset@alerongroup.com",
    "contact_phone": "0207 2397908"
  },
  {
    "supplier_name": "ALPINE RESOURCING LTD",
    "supplier_id": "2c1294b9-804b-42e3-8b58-3110249af4db",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.5",
          "1.6",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19"
        ]
      }
    ],
    "contact_name": "David Jones",
    "contact_email": "client@alpine.eu.com",
    "contact_phone": "0203 478 1346"
  },
  {
    "supplier_name": "ALVAREZ & MARSAL EUROPE LTD",
    "supplier_id": "276d812d-26f7-431c-bb5c-bc84e8ef5ed3",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Gerard Bredenoord",
    "contact_email": "ContactEU@alvarezandmarsal.com",
    "contact_phone": "020 7715 5200"
  },
  {
    "supplier_name": "AMEO PROFESSIONAL SERVICES LTD",
    "supplier_id": "bb24da0b-8c85-4678-a89e-c1afc08cb170",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "PJ Triplow",
    "contact_email": "info@ameogroup.com",
    "contact_phone": "01923 537740"
  },
  {
    "supplier_name": "ANALYTICS IN ACTION LTD",
    "supplier_id": "4082cd83-6c6f-461a-9a35-09060f942409",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.9"
        ]
      }
    ],
    "contact_name": "Philippa Smythe",
    "contact_email": "info@foxsmythe.com",
    "contact_phone": "07927 177199"
  },
  {
    "supplier_name": "ANDEREDE LTD",
    "supplier_id": "a49d5558-06fc-47da-b4ea-2e31f1034695",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.23"
        ]
      }
    ],
    "contact_name": "Steve Madden",
    "contact_email": "steve@anderede.co.uk",
    "contact_phone": "07986 227580"
  },
  {
    "supplier_name": "APACHE IX LTD",
    "supplier_id": "39e79689-e5d5-40c1-b8d7-fbfe3b2eaaa0",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.25"
        ]
      }
    ],
    "contact_name": "Andrew Page",
    "contact_email": "info@apacheix.co.uk",
    "contact_phone": "07407 767380"
  },
  {
    "supplier_name": "ARCADIS LLP",
    "supplier_id": "10951a01-766d-4e77-bd1e-5dbeee9341e8",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Kevin Hatton",
    "contact_email": "mctwoframework@arcadis.com",
    "contact_phone": "07500 101893"
  },
  {
    "supplier_name": "ARKE LTD",
    "supplier_id": "48e7a1fb-dd9f-4342-8e67-15a79ce4f841",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.15",
          "1.17",
          "1.18"
        ]
      }
    ],
    "contact_name": "Jess Green",
    "contact_email": "mail@arkeltd.co.uk",
    "contact_phone": "01373 858858"
  },
  {
    "supplier_name": "ARTSVENTURES LTD",
    "supplier_id": "93f7c3d6-a736-4ad1-9e84-8cb7e82ed462",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.15",
          "1.19",
          "1.23"
        ]
      }
    ]
  },
  {
    "supplier_name": "ARUM SYSTEMS LTD",
    "supplier_id": "ffc1818b-6279-44c0-960b-5f2def4bbab8",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.22",
          "1.25"
        ]
      }
    ],
    "contact_name": "Jonathan Dunn",
    "contact_email": "contact@arum.co.uk",
    "contact_phone": "07824 613262"
  },
  {
    "supplier_name": "ARYAA ASSOCIATES LTD",
    "supplier_id": "e38eb53a-4327-4199-bb82-d85724b49ab8",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Rajeev Chakraborty",
    "contact_email": "ops@aryaaltd.com",
    "contact_phone": "07837 962249"
  },
  {
    "supplier_name": "ATKINS LTD",
    "supplier_id": "6fb22464-dce1-429f-85cc-c9699c76ff99",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Jonny Hope",
    "contact_email": "ccs@atkinsglobal.com",
    "contact_phone": "01372 75 2633"
  },
  {
    "supplier_name": "ATOS IT SERVICES UK LTD",
    "supplier_id": "15d76e93-c559-4cea-adc7-105aa6920e5b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      }
    ],
    "contact_name": "Mrs. Deborah Hadley",
    "contact_email": "bcopportunities@atos.net",
    "contact_phone": "07733 315677"
  },
  {
    "supplier_name": "ATQ CONSULTANTS (UK) LTD",
    "supplier_id": "4f62f3c6-b833-4e61-9565-44a4c1595d64",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.4",
          "1.16",
          "1.17"
        ]
      }
    ],
    "contact_name": "Edward Hickman",
    "contact_email": "info@atqconsultants.co.uk"
  },
  {
    "supplier_name": "AULD MANAGEMENT CONSULTING LTD",
    "supplier_id": "0724f6f1-5777-463b-b1c8-96b89953b0aa",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Robin Auld",
    "contact_email": "info@criteriumgroup.com",
    "contact_phone": "+1 (403) 615-5609"
  },
  {
    "supplier_name": "AXIOLOGIK LTD",
    "supplier_id": "f8dae63b-e43e-4f5e-a423-ea3f2403a6ff",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.25"
        ]
      }
    ],
    "contact_name": "Adrian Stanbury",
    "contact_email": "contact@axiologik.com",
    "contact_phone": "07815 854412"
  },
  {
    "supplier_name": "B2E CONSULTING SOLUTIONS LTD",
    "supplier_id": "79810adb-8061-496a-888d-cbbe4e8340ff",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Parry Jenkins",
    "contact_email": "parry.jenkins@b2econsulting.com",
    "contact_phone": "0203 475 2214"
  },
  {
    "supplier_name": "BAE SYSTEMS (OPERATIONS) LTD",
    "supplier_id": "aa33d19d-35b0-4ede-b03b-7db95af9ed21",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19"
        ]
      }
    ],
    "contact_name": "Samantha Wyss",
    "contact_email": "corda.enquiries@baesystems.com",
    "contact_phone": "01483 816000"
  },
  {
    "supplier_name": "BAE SYSTEMS APPLIED INTELLIGENCE LTD",
    "supplier_id": "ee66f99e-031c-4e74-a11f-373bdb75b3d8",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      }
    ],
    "contact_name": "Nefyn Jones",
    "contact_email": "government.tenders@baesystems.com",
    "contact_phone": "01252 373232"
  },
  {
    "supplier_name": "BAIN & COMPANY INC. UK",
    "supplier_id": "d13f67cd-e1af-4153-abde-68a878cfcab4",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Nigel Cornish",
    "contact_email": "consultancytwo.london@bain.com",
    "contact_phone": "0207 969 6010"
  },
  {
    "supplier_name": "BARINGA PARTNERS LLP",
    "supplier_id": "7f97b8d9-7b5b-4472-9577-9fc58566dc75",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.4",
          "2.5",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "robin.cooper@baringa.com",
    "contact_email": "Robin Cooper",
    "contact_phone": "07986100886"
  },
  {
    "supplier_name": "BAXENDALE ADVISORY LTD",
    "supplier_id": "267e5fe1-6458-407e-9bdb-8215e26459b1",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.14",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23"
        ]
      }
    ],
    "contact_name": "Saimah Heron",
    "contact_email": "tenders@baxendale.co.uk"
  },
  {
    "supplier_name": "BDO LLP",
    "supplier_id": "2ac95472-cee4-400d-8319-d19946e28636",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "James Nicholls",
    "contact_email": "publicsectorsales@bdo.co.uk",
    "contact_phone": "020 7486 5888"
  },
  {
    "supplier_name": "BEARINGPOINT LTD",
    "supplier_id": "f30e7883-80ab-43cf-a463-586aabdc84d9",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Tony Farnfield",
    "contact_email": "tony.farnfield@bearingpoint.com",
    "contact_phone": "07970 379073"
  },
  {
    "supplier_name": "BENCHMARK MANAGEMENT CONSULTING LTD",
    "supplier_id": "6c1eb3fd-8d2e-4268-805a-5bcc615382f8",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Claire Holditch",
    "contact_email": "enquiries@bmchealth.co.uk",
    "contact_phone": "0161 2661997"
  },
  {
    "supplier_name": "BEST PRACTICE GROUP PLC",
    "supplier_id": "5d0a53e2-a1ad-4484-95c8-277f5ffbe0f1",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.7",
          "1.12",
          "1.13",
          "1.15",
          "1.17",
          "1.19",
          "1.20"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.24",
          "2.25",
          "2.28",
          "2.29"
        ]
      }
    ],
    "contact_name": "Allan Watton",
    "contact_email": "advice@bestpracticegroup.com",
    "contact_phone": "0845 345 0130"
  },
  {
    "supplier_name": "BETTER GROUP LTD",
    "supplier_id": "6c4e1c54-ace9-4fa6-9fa4-0398cb8e472d",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Marc Cohen",
    "contact_email": "opportunities@bettergov.co.uk",
    "contact_phone": "07525 017569"
  },
  {
    "supplier_name": "BLOOM PROCUREMENT SERVICES LTD",
    "supplier_id": "12cde805-3821-4dc5-99e4-1287c54f4dfd",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.3",
          "2.5",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.25",
          "2.28",
          "2.30",
          "2.32"
        ]
      }
    ],
    "contact_name": "Alison Colyer",
    "contact_email": "ccsbid@bloom.services",
    "contact_phone": "020 3948 9400"
  },
  {
    "supplier_name": "BMT HI-Q SIGMA LTD",
    "supplier_id": "cbba2c49-7e70-4920-9795-478766065690",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Edyta Redfern",
    "contact_email": "bidmgt@bmt-hqs.com",
    "contact_phone": "07717 705919"
  },
  {
    "supplier_name": "BOURTON GROUP LLP",
    "supplier_id": "fc4ed4d9-ea3f-4917-9a43-ac891c587feb",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.3",
          "1.4",
          "1.8",
          "1.15"
        ]
      }
    ],
    "contact_name": "Allison Tennant",
    "contact_email": "info@bourton.co.uk",
    "contact_phone": "01926 633333"
  },
  {
    "supplier_name": "BRAMBLE HUB LTD",
    "supplier_id": "4c6508f7-9e20-4e42-a82d-49f29e1aaf43",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Neil Simpson",
    "contact_email": "contact@bramblehub.co.uk",
    "contact_phone": "020 7735 0030"
  },
  {
    "supplier_name": "BRIGHTFIELD STRATEGIES (UK) LTD",
    "supplier_id": "c958252c-6ce0-4dcf-ae3e-a29ee32765ba",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.6",
          "2.8",
          "2.10",
          "2.11",
          "2.13",
          "2.14",
          "2.16",
          "2.18",
          "2.19",
          "2.20",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31"
        ]
      }
    ],
    "contact_name": "Matt Jessop",
    "contact_email": "emeatenders@brightfieldstrategies.com",
    "contact_phone": "07710 948532"
  },
  {
    "supplier_name": "BUSINESS REFORM LTD",
    "supplier_id": "e8c6cf5d-c31e-441d-9a9d-9dc73f0fac90",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22"
        ]
      }
    ],
    "contact_name": "Clare Campbell",
    "contact_email": "info@businessreform.co.uk",
    "contact_phone": "01244 953 600"
  },
  {
    "supplier_name": "BUYINGTEAM LTD",
    "supplier_id": "38f65f93-ce1d-4a60-8117-3daec11416eb",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.16",
          "1.17",
          "1.19"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Simon Geale",
    "contact_email": "ronan.carter@proximagroup.com",
    "contact_phone": "0203 465 4500"
  },
  {
    "supplier_name": "CACI LTD",
    "supplier_id": "9915cd3b-9e23-45e7-92ad-d344ef1b4111",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.24"
        ]
      }
    ],
    "contact_name": "Dominic Rowles",
    "contact_email": "scronin@cci.co.uk",
    "contact_phone": "0207 6026000"
  },
  {
    "supplier_name": "CADENCE INNOVA LTD",
    "supplier_id": "97947b7f-cdf1-4c3f-aad3-d0077d4df98b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.27",
          "2.28",
          "2.31"
        ]
      }
    ],
    "contact_name": "Jane Barrett",
    "contact_email": "jane.barrett@cadenceinnova.com",
    "contact_phone": "020 3858 0086"
  },
  {
    "supplier_name": "CAJA LTD",
    "supplier_id": "cabb9fcd-26a0-4b88-b120-6092375b5883",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.22"
        ]
      }
    ],
    "contact_name": "Nigel Guest",
    "contact_email": "admin@cajagroup.com",
    "contact_phone": "01782 443 018"
  },
  {
    "supplier_name": "CAMPBELL TICKELL LTD",
    "supplier_id": "9df4cfff-089e-4665-92fc-4109976f7a8b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.16",
          "1.17",
          "1.18",
          "1.20",
          "1.22"
        ]
      }
    ],
    "contact_name": "Liz Zacharias",
    "contact_email": "tenders@campbelltickell.com",
    "contact_phone": "020 8830 6777"
  },
  {
    "supplier_name": "CANDESIC LTD",
    "supplier_id": "53e0c538-ce48-441f-871a-ae11c299ffd3",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.16",
          "1.17",
          "1.18",
          "1.21",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Dr Michelle Tempest",
    "contact_email": "ctse@candesic.com",
    "contact_phone": "0207 0967682"
  },
  {
    "supplier_name": "CAPGEMINI UK PLC",
    "supplier_id": "f7c0f1c2-293d-4d4d-90b5-8c2d4d833d71",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Alex Slater",
    "contact_email": "publicsector.opps.uk@capgemini.com",
    "contact_phone": "0330 588 8000"
  },
  {
    "supplier_name": "CAPITA BUSINESS SERVICES LTD",
    "supplier_id": "fb61168a-597c-4812-a21a-9079c23f3eb0",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      }
    ],
    "contact_name": "Gill Walker",
    "contact_email": "MCFAdmin@capita.co.uk",
    "contact_phone": "07976 812978"
  },
  {
    "supplier_name": "CARBON LIMITING TECHNOLOGIES LTD",
    "supplier_id": "f8a3285c-af15-47e1-b12d-b8ce98f1de12",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.11",
          "1.16",
          "1.17",
          "1.19",
          "1.21"
        ]
      }
    ],
    "contact_name": "Jeffrey Beyer",
    "contact_email": "jeffrey.beyer@carbonlimitingtechnologies.com",
    "contact_phone": "07706 108808"
  },
  {
    "supplier_name": "CARBON TRUST ADVISORY LTD",
    "supplier_id": "b8b6f365-6be8-4ae4-8279-d3ae8f5d47b7",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.21"
        ]
      }
    ],
    "contact_name": "Stefania Omassoli",
    "contact_email": "tenders@carbontrust.co.uk",
    "contact_phone": "020 7170 7000"
  },
  {
    "supplier_name": "CARBONBIT LTD",
    "supplier_id": "31609bbf-0ca3-40c4-a7bf-875d7f0644e2",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23"
        ]
      }
    ],
    "contact_name": "Philip Hargreaves",
    "contact_email": "Philip.Hargreaves@carbonbit.com",
    "contact_phone": "01772 970 210"
  },
  {
    "supplier_name": "CARNALL FARRAR LTD",
    "supplier_id": "cb3be4fd-3b91-44e0-8c73-d85311bf0512",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Krystina Wallis",
    "contact_email": "contracts@carnallfarrar.com",
    "contact_phone": "0203 770 7536"
  },
  {
    "supplier_name": "CARTESIAN LTD",
    "supplier_id": "4735771b-43ec-4906-b54c-2f154c380462",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.4",
          "1.6",
          "1.8",
          "1.12",
          "1.13",
          "1.16",
          "1.19",
          "1.20",
          "1.22",
          "1.24"
        ]
      }
    ],
    "contact_name": "Michael Dargue",
    "contact_email": "tenders@cartesian.com",
    "contact_phone": "020 7643 5477"
  },
  {
    "supplier_name": "CATALYST CONSULTING LTD",
    "supplier_id": "6ac2595d-03bc-4d4d-b914-0a6a2cdc68fc",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.8",
          "1.11",
          "1.16",
          "1.19",
          "1.20",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Elizabeth Wilkinson",
    "contact_email": "info@catalystconsulting.co.uk",
    "contact_phone": "01926 408602"
  },
  {
    "supplier_name": "CERTES COMPUTING LTD",
    "supplier_id": "dafa6f9f-1a0a-45f6-9323-7d1065d496ee",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.18",
          "1.19"
        ]
      }
    ],
    "contact_name": "Richard Copeland",
    "contact_email": "consulting@certes.co.uk",
    "contact_phone": "01675 468968"
  },
  {
    "supplier_name": "CERTUS ADVISORY LTD",
    "supplier_id": "e71b2491-cf22-4680-b22c-ceefe82cb4f3",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Will Hampton",
    "contact_email": "info@certusadvisory.co.uk"
  },
  {
    "supplier_name": "CHANNEL 3 CONSULTING LTD",
    "supplier_id": "0595cb4b-4681-4c95-8171-7b945b82a26c",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.24"
        ]
      }
    ],
    "contact_name": "George Jackson",
    "contact_email": "info@channel3goup.co.uk",
    "contact_phone": "07988 948470"
  },
  {
    "supplier_name": "CHAUCER GROUP LTD",
    "supplier_id": "b7e36f4c-9188-4712-b59c-0d455ea53d7a",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Natalia Sokolova",
    "contact_email": "accounts@chaucer.com",
    "contact_phone": "0203 141 8400"
  },
  {
    "supplier_name": "CHRISALYST LTD",
    "supplier_id": "f6330ebb-7102-46d1-840d-eea0f454bc1d",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.3",
          "1.4",
          "1.7",
          "1.8",
          "1.11",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.25"
        ]
      }
    ],
    "contact_name": "Christine Lithgow Smith",
    "contact_email": "info@chrisalyst.com",
    "contact_phone": "07896 883636"
  },
  {
    "supplier_name": "CIPFA C.CO LTD",
    "supplier_id": "70488a73-eff8-4039-874e-de2919424ece",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.23"
        ]
      }
    ],
    "contact_name": "Natalie Abraham",
    "contact_email": "speaktous@wearec.co",
    "contact_phone": "07834 686 136"
  },
  {
    "supplier_name": "CIVICA UK LTD",
    "supplier_id": "bd923b26-9d1b-4258-b1fc-7608ff366d80",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.7",
          "1.15",
          "1.17",
          "1.18",
          "1.19",
          "1.24"
        ]
      }
    ],
    "contact_name": "Richard Shreeve",
    "contact_email": "bidscivicadigital@civica.co.uk",
    "contact_phone": "01225 475000"
  },
  {
    "supplier_name": "CLARASYS LTD",
    "supplier_id": "17766010-fe56-4bb9-affe-2d4c501e68dc",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.15",
          "1.19",
          "1.24"
        ]
      }
    ],
    "contact_name": "Steven Writer-Maguire",
    "contact_email": "bids@clarasys.com",
    "contact_phone": "0203 1317659"
  },
  {
    "supplier_name": "CLARITY CONSULTING ASSOCIATES LTD",
    "supplier_id": "c043c688-d14d-4583-a4d5-58d795437bda",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.23"
        ]
      }
    ],
    "contact_name": "Paul Sly",
    "contact_email": "tenders@ccal.co.uk",
    "contact_phone": "07796 356356"
  },
  {
    "supplier_name": "CLOUD 21 LTD",
    "supplier_id": "c3db73ad-003c-44f4-a70d-cad912ae868e",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.24"
        ]
      }
    ],
    "contact_name": "Michael Beckett",
    "contact_email": "bid-management@cloud21.net",
    "contact_phone": "0845 838 8694"
  },
  {
    "supplier_name": "CMC PARTNERSHIP (UK) LTD",
    "supplier_id": "c34b288f-a8a4-4c9a-b86e-a64644366bbc",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22"
        ]
      }
    ],
    "contact_name": "Pippa Willott",
    "contact_email": "tenders@cmcpartnership.com",
    "contact_phone": "01600 740 215"
  },
  {
    "supplier_name": "COLLINSON GRANT LTD",
    "supplier_id": "5d9b9969-952a-4373-9f7e-647f823a37c3",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.25"
        ]
      }
    ],
    "contact_name": "Joe Glackin",
    "contact_email": "postmaster@collinsongrant.com",
    "contact_phone": "0161 703 5600"
  },
  {
    "supplier_name": "COMMUNITY RESOURCING LTD",
    "supplier_id": "9fbfb129-fd38-422f-a272-d2e74ab56da8",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.16",
          "1.17",
          "1.22",
          "1.24"
        ]
      }
    ],
    "contact_name": "Simon Kenniford",
    "contact_email": "simon.kenniford@retinue-solutions.com",
    "contact_phone": "0207 2640737"
  },
  {
    "supplier_name": "CONCERTO PARTNERS LLP",
    "supplier_id": "0562234b-ce7e-4366-8910-718eeb346304",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.7",
          "1.9",
          "1.13",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.21",
          "1.24"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.3",
          "2.8",
          "2.10",
          "2.11",
          "2.13",
          "2.14",
          "2.18",
          "2.21",
          "2.24",
          "2.25"
        ]
      }
    ],
    "contact_name": "Matthew Symes",
    "contact_email": "tenders@concerto.uk.com",
    "contact_phone": "0207 4044303"
  },
  {
    "supplier_name": "CONNECT ASSIST LTD",
    "supplier_id": "b044d7e7-541e-4a44-b1e3-547c7eec77a7",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.11",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22"
        ]
      }
    ],
    "contact_name": "Adam Wilkinson",
    "contact_email": "adam.wilkinson@connectassist.co.uk",
    "contact_phone": "07725 249660"
  },
  {
    "supplier_name": "CORNERSTONE PROPERTY ASSETS LTD",
    "supplier_id": "a4a82450-5e5c-41a0-a236-0ca6950155dc",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Sara Waller",
    "contact_email": "info@cornerstoneassets.co.uk",
    "contact_phone": "07967 509053"
  },
  {
    "supplier_name": "CORNWELL BUSINESS CONSULTANTS LTD",
    "supplier_id": "048a634d-16f5-4644-9d0e-b5314f258030",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.24"
        ]
      }
    ],
    "contact_name": "Dominic Cornwell",
    "contact_email": "info@cornwellbc.co.uk",
    "contact_phone": "01372 454648"
  },
  {
    "supplier_name": "COSTAIN LTD",
    "supplier_id": "f8565733-9872-4c7d-ac38-2edc05cfc2f2",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.21"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      }
    ],
    "contact_name": "Adam Bennett",
    "contact_email": "adam.bennett@costain.com",
    "contact_phone": "07717 838866"
  },
  {
    "supplier_name": "CPC PROJECT SERVICES LLP",
    "supplier_id": "2f92298c-0f6b-4fa8-88ff-1b96a23635bd",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20"
        ]
      }
    ],
    "contact_name": "Mike Hughes",
    "contact_email": "info@cpcprojectservices.com",
    "contact_phone": "0207 539 4750"
  },
  {
    "supplier_name": "CRA INTERNATIONAL UK LTD",
    "supplier_id": "7346fa17-c341-4886-ab2c-3b2f54c64cb6",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.6",
          "1.8",
          "1.11",
          "1.23"
        ]
      }
    ],
    "contact_name": "Deb Resnick",
    "contact_email": "london@marakon.com",
    "contact_phone": "001 2125207205"
  },
  {
    "supplier_name": "CREST ADVISORY (UK) LTD",
    "supplier_id": "e6753bef-93b3-4b99-bf44-6ce0254aa99a",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.6",
          "1.8",
          "1.12",
          "1.16",
          "1.18"
        ]
      }
    ],
    "contact_name": "Harvey Redgrave",
    "contact_email": "contact@crestadvisory.com",
    "contact_phone": "020 3542 8993"
  },
  {
    "supplier_name": "CURRIE & BROWN UK LTD",
    "supplier_id": "b0a7693c-4c92-466e-a2d0-1b1b450f3fe4",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.6",
          "1.8",
          "1.9",
          "1.12",
          "1.13",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.21",
          "1.22"
        ]
      }
    ],
    "contact_name": "Helen Pickering",
    "contact_email": "hilary.gilbert-jones@curriebrown.com",
    "contact_phone": "020 7061 9000"
  },
  {
    "supplier_name": "CURZON & COMPANY LLP",
    "supplier_id": "bf7df2f5-96c5-4e6a-a18d-c874b6f85e84",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.9",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Simon Green",
    "contact_email": "CCS@curzoncompany.com",
    "contact_phone": "0844 669 6197"
  },
  {
    "supplier_name": "CW INFRASTRUCTURE (UK) LTD",
    "supplier_id": "132bcc10-8e37-485b-bc62-98501a2a8ac3",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.17",
          "1.19"
        ]
      }
    ],
    "contact_name": "Joe Dowling",
    "contact_email": "info@cw-infrastructure.com",
    "contact_phone": "0330 1132427"
  },
  {
    "supplier_name": "DEALWORKS LTD",
    "supplier_id": "e8b10eaf-8f1b-4940-9ef6-4a6bd03bc066",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23"
        ]
      }
    ],
    "contact_name": "jacqui archer",
    "contact_email": "info@dealworks.co.uk",
    "contact_phone": "07526 724400"
  },
  {
    "supplier_name": "DELOITTE LLP",
    "supplier_id": "b1822ef2-383b-474b-8fd8-e2226167a39c",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Toby Spanier",
    "contact_email": "publicsectorbidteam@deloitte.co.uk",
    "contact_phone": "020 7303 8628"
  },
  {
    "supplier_name": "DENOVÉ LLP",
    "supplier_id": "eafe7485-2aaf-4409-b2ab-74fd09e46f6d",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.7",
          "1.8",
          "1.19"
        ]
      }
    ],
    "contact_name": "Roger Newman",
    "contact_email": "learnmore@denove.com",
    "contact_phone": "07950 396205"
  },
  {
    "supplier_name": "DEYTONBELL LTD",
    "supplier_id": "b3d8a78a-c432-4659-b05c-50337bceba62",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.11",
          "1.13",
          "1.16",
          "1.17",
          "1.19",
          "1.23",
          "1.25"
        ]
      }
    ]
  },
  {
    "supplier_name": "DISCIDIUM LTD",
    "supplier_id": "e740fd2d-b818-4c08-957f-323fbee49213",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24"
        ]
      }
    ],
    "contact_name": "Kevin Tallett",
    "contact_email": "information@discidium.co.uk",
    "contact_phone": "01732 752030"
  },
  {
    "supplier_name": "DRUMMOND & DRUMMOND LTD",
    "supplier_id": "e6743705-845d-4818-bbcd-40e26d1c478f",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.15",
          "1.16",
          "1.17",
          "1.19"
        ]
      }
    ],
    "contact_name": "Andrew Drummond",
    "contact_email": "info@2drummondltd.com",
    "contact_phone": "07554 778 438"
  },
  {
    "supplier_name": "EARLSDON CONSULTING LTD",
    "supplier_id": "c0e8e2a8-475c-42b4-961c-7c3bb8eedee5",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20"
        ]
      }
    ],
    "contact_name": "Adam Rogerson",
    "contact_email": "A.rogerson@zenith-projects.co.uk",
    "contact_phone": "07533 669245"
  },
  {
    "supplier_name": "ECONOMIC INSIGHT LTD",
    "supplier_id": "191032c1-279e-4292-9a4b-eae66e06899f",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.4",
          "1.6",
          "1.9",
          "1.12",
          "1.13",
          "1.17",
          "1.18"
        ]
      }
    ],
    "contact_name": "Sam Williams",
    "contact_email": "info@economic-insight.com",
    "contact_phone": "0207 100 3746"
  },
  {
    "supplier_name": "EDGE PUBLIC SOLUTIONS LTD",
    "supplier_id": "990abcdb-2a40-48a3-a74a-0c88bfdaa522",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21"
        ]
      }
    ],
    "contact_name": "Mr James Aspin",
    "contact_email": "enquiries@edgepublicsolutions.co.uk",
    "contact_phone": "07800 793979"
  },
  {
    "supplier_name": "EIB PROFESSIONAL SERVICES LTD",
    "supplier_id": "8df508dc-e17a-418e-915f-38fdbe9db410",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.11",
          "1.16",
          "1.17",
          "1.19"
        ]
      }
    ],
    "contact_name": "Richard Roddie",
    "contact_email": "ExcellenceinBusiness@EiBLLP.onmicrosoft.com",
    "contact_phone": "07973 909373"
  },
  {
    "supplier_name": "EMBER GROUP LTD",
    "supplier_id": "5f5f0ed9-76a9-4a13-bfde-45b5758a8abf",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.23",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31"
        ]
      }
    ],
    "contact_name": "Chris Mcilduff",
    "contact_email": "finance@embergroup.co.uk",
    "contact_phone": "07715 493204"
  },
  {
    "supplier_name": "ENVIRONMENTAL FINANCE LTD",
    "supplier_id": "972ec842-79e8-4003-b560-8cd622598bb3",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.16",
          "1.17",
          "1.19",
          "1.20"
        ]
      }
    ],
    "contact_name": "Alicia Gibson",
    "contact_email": "enquiries@environmentalfinance.co.uk",
    "contact_phone": "07725 650524"
  },
  {
    "supplier_name": "EQUAL EXPERTS UK LTD",
    "supplier_id": "28e62c3a-80b9-4ce1-bea8-370bde1d7629",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.24"
        ]
      }
    ],
    "contact_name": "Louis Abel",
    "contact_email": "helloUK@equalexperts.com",
    "contact_phone": "07968 157767"
  },
  {
    "supplier_name": "ERNST & YOUNG LLP",
    "supplier_id": "120d1dca-554d-400f-a92e-e56dbcefa316",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Christopher Flinter",
    "contact_email": "EYTenders@uk.ey.com",
    "contact_phone": "0121 262 4651"
  },
  {
    "supplier_name": "ESSENTIA TRADING LTD",
    "supplier_id": "cf241412-d686-4c60-9c1a-1fffd3bd20a4",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.3",
          "1.6",
          "1.8",
          "1.15",
          "1.17",
          "1.19",
          "1.20",
          "1.21"
        ]
      }
    ],
    "contact_name": "David Philliskirk",
    "contact_email": "rm6008@essentia.uk.com",
    "contact_phone": "0207 1886000"
  },
  {
    "supplier_name": "ETHICAL HEALTHCARE CONSULTING CIC",
    "supplier_id": "84ce3fbe-f68c-44d5-9619-4c2f0751bf2c",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.22"
        ]
      }
    ],
    "contact_name": "Steve Loveridge",
    "contact_email": "info@ethicalhealthcare.org.uk",
    "contact_phone": "03330 124282"
  },
  {
    "supplier_name": "EUNOMIA RESEARCH & CONSULTING LTD",
    "supplier_id": "15288899-95b3-4ffd-b3c8-33574904e405",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31"
        ]
      }
    ],
    "contact_name": "Ian Cessford",
    "contact_email": "tenders@eunomia.co.uk",
    "contact_phone": "0117 917 2265"
  },
  {
    "supplier_name": "EVISA SOLUTIONS LTD",
    "supplier_id": "aa081406-354f-4ded-8ef9-e345c9212b14",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.15",
          "1.16",
          "1.19"
        ]
      }
    ],
    "contact_name": "Rob Shaw",
    "contact_email": "info@malikshaw.com"
  },
  {
    "supplier_name": "FINYX CONSULTING LTD",
    "supplier_id": "5de9089f-42ba-4bec-a0c6-82d0e76fc66f",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.8",
          "2.12",
          "2.13",
          "2.14",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.29",
          "2.30",
          "2.31"
        ]
      }
    ],
    "contact_name": "Neil Blurton",
    "contact_email": "admin@finyx.com",
    "contact_phone": "07884 188738"
  },
  {
    "supplier_name": "FIREWOOD LTD",
    "supplier_id": "0a2303fa-7d2e-42aa-bcd1-4b970b2bd3e8",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.8",
          "1.15",
          "1.18",
          "1.19",
          "1.22",
          "1.23"
        ]
      }
    ],
    "contact_name": "Tayyab Jamil",
    "contact_email": "info@firewoodltd.com",
    "contact_phone": "07967 829922"
  },
  {
    "supplier_name": "FLINT GLOBAL LTD",
    "supplier_id": "02408cb5-faf9-4ec7-8fe3-06810e4e7a59",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.25"
        ]
      }
    ],
    "contact_name": "Catherine Davies",
    "contact_email": "info@flint-global.com",
    "contact_phone": "0203 9173630"
  },
  {
    "supplier_name": "FOUR EYES INSIGHT LTD",
    "supplier_id": "765e3df1-0bb3-44a9-b560-01bf732a4830",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.3",
          "1.4",
          "1.8",
          "1.13",
          "1.14",
          "1.16",
          "1.19"
        ]
      }
    ],
    "contact_name": "Bella Sapsworth",
    "contact_email": "frameworks@foureyes",
    "contact_phone": "0203 6665120"
  },
  {
    "supplier_name": "FRAZER-NASH CONSULTANCY LTD",
    "supplier_id": "e398abf6-6056-4dfa-9ba8-efcafd87eaca",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.8",
          "2.11",
          "2.12",
          "2.13",
          "2.17",
          "2.20",
          "2.21",
          "2.23"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Chris Cullis",
    "contact_email": "ccs@fnc.co.uk",
    "contact_phone": "01179 468904"
  },
  {
    "supplier_name": "FRONTIER ECONOMICS LTD",
    "supplier_id": "d720a9d4-94fa-4bc1-a980-d9d853ee23fd",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.25"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Alexia Haine",
    "contact_email": "framework@frontier-economics.com",
    "contact_phone": "0207 031 7000"
  },
  {
    "supplier_name": "FROST & SULLIVAN LTD",
    "supplier_id": "42eeda8a-29e6-43ad-adf7-94ff4eff22c5",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.4",
          "2.5",
          "2.8",
          "2.25"
        ]
      }
    ],
    "contact_name": "Iain Jawad",
    "contact_email": "tenders@frost.com",
    "contact_phone": "020 8996 8581"
  },
  {
    "supplier_name": "FTI CONSULTING LLP",
    "supplier_id": "c6226c96-0c3a-4236-909e-1fa9367d7359",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Lisa Goldstone",
    "contact_email": "ManagementConsultingFrameworkTwo@fticonsulting.com",
    "contact_phone": "0203 7271646"
  },
  {
    "supplier_name": "FUJITSU SERVICES LTD",
    "supplier_id": "2726a3a2-e71e-40a3-9ec2-a6b839ed60ee",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Jamie Whysall",
    "contact_email": "Government.frameworks@uk.fujitsu.com",
    "contact_phone": "07867 828254"
  },
  {
    "supplier_name": "GARTNER UK LTD",
    "supplier_id": "3765af3d-90a3-490e-b9f3-de16b0280e91",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.7",
          "1.8",
          "1.9",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20"
        ]
      }
    ],
    "contact_name": "Rachi Weerasinghe",
    "contact_email": "rachi.weerasinghe@gartner.com"
  },
  {
    "supplier_name": "GATE ONE LTD",
    "supplier_id": "893c84fe-1910-40a1-bf60-51dd941902e6",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.8",
          "2.11",
          "2.12",
          "2.13",
          "2.23",
          "2.24",
          "2.25",
          "2.27"
        ]
      }
    ],
    "contact_name": "James Swaffield",
    "contact_email": "info@gateone.co.uk",
    "contact_phone": "0207 293 0893"
  },
  {
    "supplier_name": "GE HEALTHCARE FINNAMORE LTD",
    "supplier_id": "088945e7-440e-4b37-92d2-852f44188cac",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      }
    ],
    "contact_name": "Colin Lewry",
    "contact_email": "Contact.gehcf@ge.com"
  },
  {
    "supplier_name": "GEOPLACE LLP",
    "supplier_id": "315d47a4-8918-4a9f-85a2-65afe3274942",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.6",
          "1.8",
          "1.12",
          "1.15",
          "1.16",
          "1.18",
          "1.19",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Simon Barlow",
    "contact_email": "consultancy@geoplace.co.uk",
    "contact_phone": "020 7630 4600"
  },
  {
    "supplier_name": "GGI DEVELOPMENT & RESEARCH LLP",
    "supplier_id": "eee2fc86-60b9-482e-b91d-545d06ed2f8f",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.14",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Donal Sutton",
    "contact_email": "tenders@good-governance.org.uk",
    "contact_phone": "020 7735 3085"
  },
  {
    "supplier_name": "GRANT THORNTON UK LLP",
    "supplier_id": "27f845e9-5923-46ff-a22b-635058d67608",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.7",
          "2.8",
          "2.11",
          "2.12",
          "2.15",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.30"
        ]
      }
    ],
    "contact_name": "Louise Dale",
    "contact_email": "publicsector.bids@uk.gt.com",
    "contact_phone": "0207 7283311"
  },
  {
    "supplier_name": "GRAYCE BRITAIN LTD",
    "supplier_id": "b281e74a-5390-4435-95e7-b45dc53cdede",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Victoria Birtles",
    "contact_email": "comms@grayce.co.uk",
    "contact_phone": "01625 610 991"
  },
  {
    "supplier_name": "HALL AITKEN ASSOCIATES LTD",
    "supplier_id": "d5b17b82-0d91-475e-bd33-680b3278ff37",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.16",
          "1.17",
          "1.19",
          "1.21",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "David Gourlay",
    "contact_email": "info@hallaitken.co.uk",
    "contact_phone": "0141 225 5511"
  },
  {
    "supplier_name": "HARMONIC LTD",
    "supplier_id": "784a06e2-7191-4738-b8b7-49362289b64b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.23"
        ]
      }
    ],
    "contact_name": "Toby Waters",
    "contact_email": "enquiries@harmonicltd.co.uk",
    "contact_phone": "01460 256512"
  },
  {
    "supplier_name": "HAYS SPECIALIST RECRUITMENT LTD",
    "supplier_id": "e50de6f9-8141-4b01-8146-27e0da869ab2",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.3",
          "1.8",
          "1.13",
          "1.15",
          "1.16",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.24"
        ]
      }
    ],
    "contact_name": "Alan McFarlane",
    "contact_email": "haysprojectsolutions@hays.com",
    "contact_phone": "0203 4650050"
  },
  {
    "supplier_name": "HEALTH HR UK LTD",
    "supplier_id": "7b5fd74b-f9d4-409e-848a-2645926d79f3",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Liam McGuire",
    "contact_email": "info@hhruk.co.uk",
    "contact_phone": "07909 902284"
  },
  {
    "supplier_name": "HELIOS TECHNOLOGY LTD",
    "supplier_id": "72ae2847-a04a-4616-ac0e-9d95d71b1c81",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.25"
        ]
      }
    ],
    "contact_name": "Peter Straka",
    "contact_email": "tenders@askhelios.com",
    "contact_phone": "01252 451 682"
  },
  {
    "supplier_name": "I3WORKS LTD",
    "supplier_id": "a6b2335f-ba33-4b52-8b58-d577ed694bd7",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.8",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22",
          "1.24"
        ]
      }
    ],
    "contact_name": "Ben Ames",
    "contact_email": "bd@i3works.co.uk",
    "contact_phone": "07792 903736"
  },
  {
    "supplier_name": "ICF CONSULTING SERVICES LTD",
    "supplier_id": "c778dee2-69d1-405b-9dad-ffd983574250",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.9",
          "1.12",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.21",
          "1.22",
          "1.25"
        ]
      }
    ],
    "contact_name": "Andrew Jarvis",
    "contact_email": "ConsultancyTwo@icf.com",
    "contact_phone": "020 3096 4824"
  },
  {
    "supplier_name": "IG MARKETING & BUSINESS DEVELOPMENT LTD",
    "supplier_id": "5c039983-9f95-4eee-885d-792b6a509df6",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Ian Gent",
    "contact_email": "iangent@igmbd.co.uk",
    "contact_phone": "07497 173658"
  },
  {
    "supplier_name": "IGNITE CONSULTING LTD",
    "supplier_id": "1a1c4b03-a369-4af3-ad8e-8a1eb91bafcd",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Mark Long",
    "contact_email": "info@ignite.org.uk",
    "contact_phone": "07740 947533"
  },
  {
    "supplier_name": "ILLUMINET SOLUTIONS LTD",
    "supplier_id": "2670b233-6d79-4528-bb54-93e4f0b6d12f",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.15"
        ]
      }
    ],
    "contact_name": "Steve Farmer",
    "contact_email": "enquiries@illuminetsolutions.com",
    "contact_phone": "01202 770162"
  },
  {
    "supplier_name": "IMPOWER CONSULTING LTD",
    "supplier_id": "95b6d0ac-27e4-4bf3-8af2-190004888de9",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22"
        ]
      }
    ],
    "contact_name": "Emma Ockelford",
    "contact_email": "tenders@impower.co.uk",
    "contact_phone": "0214 017 8030"
  },
  {
    "supplier_name": "IMPROVIT CONSULTING LTD",
    "supplier_id": "fd8f8e00-fdda-42f2-833e-21a8d656249b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.9",
          "1.15"
        ]
      }
    ],
    "contact_name": "Sarah Hill",
    "contact_email": "info@improvit.com",
    "contact_phone": "01494 958390"
  },
  {
    "supplier_name": "INCENDIUM CONSULTING LTD",
    "supplier_id": "93444f7d-05ee-4498-ab98-cf404617b8d7",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.15",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.29",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Valerie Bonnin",
    "contact_email": "info@incendiumconsulting.com",
    "contact_phone": "07715 771278"
  },
  {
    "supplier_name": "INCREMENTAL GROUP LTD",
    "supplier_id": "bd159a95-89c1-44fd-801a-a1ab07b1bcb7",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.6",
          "1.8",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.25"
        ]
      }
    ],
    "contact_name": "Iain Cherry",
    "contact_email": "enquiries@incrementalgroup.co.uk",
    "contact_phone": "01467 623900"
  },
  {
    "supplier_name": "IN-FORM SOLUTIONS LTD",
    "supplier_id": "ad28bf4a-5c9b-4f5e-a3e1-7a95e1218bb3",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "John Griffiths",
    "contact_email": "info@in-formsolutions.com",
    "contact_phone": "01543 560 280"
  },
  {
    "supplier_name": "INFORMATION SERVICES GROUP (EUROPE) LTD",
    "supplier_id": "f917a96d-fd1a-4afe-990b-b7f1a7db72c8",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.6",
          "1.7",
          "1.9",
          "1.13",
          "1.15",
          "1.17",
          "1.18",
          "1.19",
          "1.20"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.2",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.10",
          "2.11",
          "2.12",
          "2.15",
          "2.16",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.31"
        ]
      }
    ],
    "contact_name": "Sara Sheehan",
    "contact_email": "contactus@isg-one.com",
    "contact_phone": "07765 962989"
  },
  {
    "supplier_name": "INFORMED SOLUTIONS LTD",
    "supplier_id": "f1b6491d-110e-4f25-a54e-319715f4c571",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.15"
        ]
      }
    ],
    "contact_name": "Philip Lucas",
    "contact_email": "opportunities@informed.com",
    "contact_phone": "0161 942 2000"
  },
  {
    "supplier_name": "INNER CIRCLE CONSULTING LTD",
    "supplier_id": "7ab4c6e3-1b6f-45b2-81bc-f23af3d91602",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.11",
          "1.12",
          "1.13",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23"
        ]
      }
    ],
    "contact_name": "Andrew Starkie",
    "contact_email": "astarkie@innercircleconsulting.co.uk",
    "contact_phone": "07788 727052"
  },
  {
    "supplier_name": "INNOVATION STRATEGY LTD",
    "supplier_id": "fa90d278-2767-4f2d-98b8-291e7211fef0",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.16",
          "1.17",
          "1.19"
        ]
      }
    ],
    "contact_name": "Luke Player",
    "contact_email": "info@innovationstrategy.co.uk",
    "contact_phone": "07751 159046"
  },
  {
    "supplier_name": "INNOVIFY UK LTD",
    "supplier_id": "0fe2bbbc-0cd9-4dba-a720-91255f981c36",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Maulik Sailor",
    "contact_email": "bids@innovify.com",
    "contact_phone": "07944 282874"
  },
  {
    "supplier_name": "INSOURCE SELECT LTD",
    "supplier_id": "4dca4d65-8917-4799-8a02-9ee74d298efc",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.3",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.14",
          "1.15",
          "1.18",
          "1.19",
          "1.20",
          "1.21"
        ]
      }
    ],
    "contact_name": "Gary Ferguson",
    "contact_email": "contact@source-group.uk",
    "contact_phone": "0203 727 4186"
  },
  {
    "supplier_name": "INZENKA LTD",
    "supplier_id": "667784db-c326-4f1a-9456-26df67d69e05",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Stephen Deadmon",
    "contact_email": "hello@inzenka.com",
    "contact_phone": "0207 7223888"
  },
  {
    "supplier_name": "JACOBS UK LTD",
    "supplier_id": "dfba7e01-79cf-4caf-b66a-d355dcd57502",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.27",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Phil Morgans",
    "contact_email": "Philip.morgans@jacobs.com",
    "contact_phone": "01905 361218"
  },
  {
    "supplier_name": "JK DIGITAL CONSULTING LTD",
    "supplier_id": "60d5477c-5259-4795-86ad-cf93fe2114c0",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.6",
          "1.7",
          "1.8",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.23",
          "1.24"
        ]
      }
    ],
    "contact_name": "James Beeson",
    "contact_email": "enquiries@rikadigital.com",
    "contact_phone": "07496 648230"
  },
  {
    "supplier_name": "KAINOS SOFTWARE LTD",
    "supplier_id": "4c9837ae-c833-493d-b4d3-0ed8e7ee0ed9",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Gareth Black",
    "contact_email": "presales@kainos.com",
    "contact_phone": "02890 571100"
  },
  {
    "supplier_name": "KALEIDOSCOPE CONSULTANTS LTD",
    "supplier_id": "147bf03e-b5d9-4cd5-8997-723a1e9d5799",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.24"
        ]
      }
    ],
    "contact_name": "David Stone",
    "contact_email": "info@kaleidoscopeconsultants.com",
    "contact_phone": "07947 052704"
  },
  {
    "supplier_name": "KAREN ELSON CONSULTING LTD",
    "supplier_id": "078bc8a8-156e-49b8-aa05-7f72097d2ee0",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Karen Elson",
    "contact_email": "info@co-cre8.org.uk",
    "contact_phone": "07854 570835"
  },
  {
    "supplier_name": "KELLOGG BROWN & ROOT LTD",
    "supplier_id": "51564a13-600b-433b-94ab-c89e02cf2907",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13"
        ]
      }
    ],
    "contact_name": "Tim Barber",
    "contact_email": "kbrresilience@kbr.com",
    "contact_phone": "01372 865000"
  },
  {
    "supplier_name": "KINGSGATE INTERIM ADVISORY & INVESTMENTS LTD",
    "supplier_id": "19032d62-b818-4c6a-b119-bc16003a2561",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.14",
          "1.16",
          "1.19"
        ]
      }
    ],
    "contact_name": "Sam Cope",
    "contact_email": "enquiries@kingsgate-uk.com",
    "contact_phone": "07557 879656"
  },
  {
    "supplier_name": "KNOWLEDGE MANAGEMENT & TRANSFER LTD",
    "supplier_id": "804168e0-11ac-407c-9b34-06c295b6fd10",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.16",
          "1.17",
          "1.19",
          "1.21",
          "1.22"
        ]
      }
    ],
    "contact_name": "Max Pardo-Roques",
    "contact_email": "info@kmandt.com"
  },
  {
    "supplier_name": "KORN FERRY HAY GROUP LTD",
    "supplier_id": "a28cdaa7-4689-4ca3-b421-71bbc942192f",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.6",
          "1.8",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.16",
          "1.17",
          "1.18",
          "1.25"
        ]
      }
    ],
    "contact_name": "Joanna Matthews",
    "contact_email": "Bid.Manager@KornFerry.com",
    "contact_phone": "0203 8192217"
  },
  {
    "supplier_name": "KPMG LLP",
    "supplier_id": "c095092c-3a4d-4f5f-8a57-4a23431986f9",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Matthew Collins",
    "contact_email": "PSopportunities@kpmg.co.uk",
    "contact_phone": "0207 6945384"
  },
  {
    "supplier_name": "L.E.K. CONSULTING LLP",
    "supplier_id": "8dbd8c3a-033d-45c2-af85-4c27bbd9c292",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "James Lloyd",
    "contact_email": "e-sourcing@lek.com",
    "contact_phone": "0207 389 7200"
  },
  {
    "supplier_name": "LA INTERNATIONAL COMPUTER CONSULTANTS LTD",
    "supplier_id": "5a01ec88-a07a-4914-ad0c-4f9d9ba2955c",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.5",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Tom Robinson",
    "contact_email": "bidmanagement@lainternational.com",
    "contact_phone": "01782 203040"
  },
  {
    "supplier_name": "LANE4 MANAGEMENT GROUP LTD",
    "supplier_id": "2d845d3a-d921-449c-b05e-ddffac06c417",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.8",
          "1.15",
          "1.16",
          "1.19",
          "1.20",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Adam Stuart",
    "contact_email": "enquiries@lane4.co.uk",
    "contact_phone": "01628 533733"
  },
  {
    "supplier_name": "LEIDOS INNOVATIONS UK LTD",
    "supplier_id": "715aeb0d-8e14-45e6-bab3-1b71d66e471b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Morag Young",
    "contact_email": "publicsector@leidos.com",
    "contact_phone": "0333 6000 200"
  },
  {
    "supplier_name": "LIAISON FINANCIAL SERVICES LTD",
    "supplier_id": "19640019-1a26-49cf-9b2d-7e05fc74bc7d",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.13",
          "1.14",
          "1.16",
          "1.19",
          "1.20",
          "1.25"
        ]
      }
    ],
    "contact_name": "Philippa Debono",
    "contact_email": "ccsMCF2@liaisonfs.com",
    "contact_phone": "07551 154404"
  },
  {
    "supplier_name": "LINEA CONSULTING LTD",
    "supplier_id": "dcefc1cb-f6e7-4148-b748-cfe81d57b55c",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Claire Schneider",
    "contact_email": "claire.schneider@lineagroup.net",
    "contact_phone": "01244 421095"
  },
  {
    "supplier_name": "LOCAL PARTNERSHIPS LLP",
    "supplier_id": "fc5b2a24-8d4f-4132-8f57-efd0739c6a8f",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31"
        ]
      }
    ],
    "contact_name": "Stewart Rolls",
    "contact_email": "lpenquiries@local.gov.uk",
    "contact_phone": "07554 334 915"
  },
  {
    "supplier_name": "LONDON ECONOMICS LTD",
    "supplier_id": "c53cda30-6118-4a41-bc02-c891ecf7cce6",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.9",
          "1.12",
          "1.13",
          "1.15",
          "1.17",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Charlotte Duke",
    "contact_email": "info@londoneconomics.co.uk",
    "contact_phone": "0203 7017705"
  },
  {
    "supplier_name": "LTS HEALTH UK LTD",
    "supplier_id": "5f31c4e1-10e0-4235-a7f8-84ad2ecd961f",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.21",
          "1.23"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Francisco Munoz",
    "contact_email": "tenders@ltshealth.com",
    "contact_phone": "07809 707511"
  },
  {
    "supplier_name": "LUCERNA PARTNERS LTD",
    "supplier_id": "df030657-a127-4dc8-a7c5-d11a4a62c1cc",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.25"
        ]
      }
    ],
    "contact_name": "Heather Clayton",
    "contact_email": "enquiries@lucernapartners.com",
    "contact_phone": "0207 1935912"
  },
  {
    "supplier_name": "M4 MANAGED SERVICES INTERNATIONAL LTD",
    "supplier_id": "4d4dc6d5-670d-4907-8e69-00412505b376",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19"
        ]
      }
    ],
    "contact_name": "Claire Turner",
    "contact_email": "procurement@m4int.com",
    "contact_phone": "02920 647647"
  },
  {
    "supplier_name": "MACE LTD",
    "supplier_id": "38d6e920-c9f7-452c-b250-c9c694b65d76",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.6",
          "2.8",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.17",
          "2.18",
          "2.20",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.29",
          "2.30",
          "2.31"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      }
    ],
    "contact_name": "James Merrett",
    "contact_email": "bid.team@macegroup.com",
    "contact_phone": "020 3522 4256"
  },
  {
    "supplier_name": "MANAGEMENTORS LTD",
    "supplier_id": "30c5f423-4c1a-402a-bf3b-45b283df6c8e",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.3",
          "1.4",
          "1.8",
          "1.19"
        ]
      }
    ],
    "contact_name": "David Beggs",
    "contact_email": "tenders@managementors.co.uk",
    "contact_phone": "01256 883939"
  },
  {
    "supplier_name": "MANIFESTO DIGITAL LTD",
    "supplier_id": "bf968024-81f1-4ca1-8a74-33e198080c8a",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Jim Bowes",
    "contact_email": "hello@manifesto.co.uk",
    "contact_phone": "0207 2262805"
  },
  {
    "supplier_name": "MARKET & OPINION RESEARCH INTERNATIONAL LTD",
    "supplier_id": "0d5a8b7c-52bd-4095-9454-422c8a680a6b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.6",
          "1.9",
          "1.12",
          "1.18"
        ]
      }
    ],
    "contact_name": "Nick Pettigrew",
    "contact_email": "tenders@ipsos.com",
    "contact_phone": "0203 0595000"
  },
  {
    "supplier_name": "MASON ADVISORY LTD",
    "supplier_id": "64f88909-90e1-4ebc-90cd-eb9281035501",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.6",
          "2.8",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.17",
          "2.18",
          "2.20",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.27",
          "2.29",
          "2.30",
          "2.31"
        ]
      }
    ],
    "contact_name": "Duncan Swan",
    "contact_email": "contact@masonadvisory.com",
    "contact_phone": "0333 301 0093"
  },
  {
    "supplier_name": "MATRIX INSIGHT LTD",
    "supplier_id": "3091b82b-218a-4ef2-9389-965b43966b6c",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.25"
        ]
      }
    ],
    "contact_name": "Jacqueline Mallender",
    "contact_email": "tenders@optimityadvisors.com",
    "contact_phone": "020 7553 4800"
  },
  {
    "supplier_name": "MAZARS LLP",
    "supplier_id": "3c5864cf-1547-46d8-aa8a-c3601a5bd018",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.24"
        ]
      }
    ],
    "contact_name": "Peter Cudlip",
    "contact_email": "pstenders@mazars.co.uk",
    "contact_phone": "0207 0634000"
  },
  {
    "supplier_name": "MCKINSEY & COMPANY INC. UK",
    "supplier_id": "d6f951a5-f061-41e1-80b4-b8aeeea0f751",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.17",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.27",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Katrina Johnstone",
    "contact_email": "tenderadmin@mckinsey.com",
    "contact_phone": "0207 9615548"
  },
  {
    "supplier_name": "MEDLEY BUSINESS SOLUTIONS LTD",
    "supplier_id": "4f815537-47a2-4131-b196-7e3a818e2784",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Tim Eglen",
    "contact_email": "info@medley.co.uk",
    "contact_phone": "07770 384418"
  },
  {
    "supplier_name": "MELBOURNE CONSULTING SERVICES LTD",
    "supplier_id": "9f221f8b-45bf-4017-a74a-da34c9529049",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "James Brathwaite",
    "contact_email": "enquiries@pixelglobal.co.uk",
    "contact_phone": "07515 487500"
  },
  {
    "supplier_name": "MERIDIAN PRODUCTIVITY LTD",
    "supplier_id": "7c44d387-f5ff-4f5d-b3fc-8595ef5ac8b3",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.21",
          "1.22"
        ]
      }
    ],
    "contact_name": "Elwyn Evans",
    "contact_email": "info@meridianpl.co.uk",
    "contact_phone": "0131 6258500"
  },
  {
    "supplier_name": "METHODS BUSINESS & DIGITAL TECHNOLOGY LTD",
    "supplier_id": "cfe6584d-b9dd-41f3-a231-a7885c088522",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.23"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.3",
          "2.4",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.27",
          "2.29",
          "2.31"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Tara O''Connell",
    "contact_email": "bidteam@methods.co.uk",
    "contact_phone": "020 7240 1121"
  },
  {
    "supplier_name": "MITIE LTD",
    "supplier_id": "12b39a88-7539-4797-a5f2-d9af800aab17",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.17",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.25"
        ]
      }
    ],
    "contact_name": "Iain Franklin",
    "contact_email": "info@source8.com",
    "contact_phone": "07971 020190"
  },
  {
    "supplier_name": "MODIS INTERNATIONAL LTD",
    "supplier_id": "74013379-71c1-410d-a5cd-79647519a777",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.24"
        ]
      }
    ],
    "contact_name": "Sue Waller",
    "contact_email": "admin@ajilon.co.uk",
    "contact_phone": "0754 757 0554"
  },
  {
    "supplier_name": "MONOCHROME CONSULTANCY LTD",
    "supplier_id": "d467d6ea-eb93-4e6d-951e-5858d33b2ff0",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.3",
          "1.4",
          "1.5",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.16",
          "1.17",
          "1.19",
          "1.20"
        ]
      }
    ],
    "contact_name": "Daniel Wright",
    "contact_email": "contactus@monochromeconsultancy.co.uk"
  },
  {
    "supplier_name": "MOORE STEPHENS LLP",
    "supplier_id": "4cf6d922-d8ed-4dc9-9f65-1c900f341d2b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Sarah Hillary",
    "contact_email": "msconsortium@moorestephens.com",
    "contact_phone": "0207 651 1346"
  },
  {
    "supplier_name": "MOORHOUSE CONSULTING LTD",
    "supplier_id": "b3c51670-e05b-4f94-bffb-7d9f8ed7d54a",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.5",
          "2.6",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Richard Goold",
    "contact_email": "centralbids@moorhouseconsulting.com",
    "contact_phone": "020 3004 4482"
  },
  {
    "supplier_name": "MOTT MACDONALD LTD",
    "supplier_id": "c2c625c5-3c8c-4977-924c-7cccad246b4d",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Tiffany Morgan",
    "contact_email": "SMO-CCSConsultancyTwoPhase1@365site.mottmac.com",
    "contact_phone": "01223 463918"
  },
  {
    "supplier_name": "MOZAIC SERVICES LTD",
    "supplier_id": "5349e002-ed5c-4ba3-8991-8310b9b45901",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.7",
          "1.8",
          "1.9",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.21",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.27",
          "2.29",
          "2.31"
        ]
      }
    ],
    "contact_name": "David Courtley",
    "contact_email": "david.courtley@mozaic.net",
    "contact_phone": "0203 709 1625"
  },
  {
    "supplier_name": "MUTUAL VENTURES LTD",
    "supplier_id": "b67817f6-658c-4995-8536-43cdc220128b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Mark Bandalli",
    "contact_email": "info@mutualventures.co.uk",
    "contact_phone": "020 3714 3901"
  },
  {
    "supplier_name": "N E L CSU",
    "supplier_id": "06273108-0483-456c-ace8-3a3b958c3d72",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.24"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.14",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.22",
          "2.24"
        ]
      }
    ],
    "contact_name": "Laura Churchill",
    "contact_email": "nelcsu.businessdevelopment@nhs.net",
    "contact_phone": "07894 491 766"
  },
  {
    "supplier_name": "NAVIGANT CONSULTING (EUROPE) LTD",
    "supplier_id": "6541c815-2f48-4a7e-9939-a51b1285bb7b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.21",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.5",
          "2.6",
          "2.8",
          "2.18",
          "2.20",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.29",
          "2.31"
        ]
      }
    ],
    "contact_name": "Richard Robinson",
    "contact_email": "tenders@navigant.com",
    "contact_phone": "0207 4691111"
  },
  {
    "supplier_name": "NEWTON EUROPE LTD",
    "supplier_id": "f4088817-7e4d-4d7c-9b73-817674396078",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      }
    ],
    "contact_name": "Rachel Lenik",
    "contact_email": "tenders@newtoneurope.com",
    "contact_phone": "01865 601300"
  },
  {
    "supplier_name": "NHS ARDEN & GREATER EAST MIDLANDS CSU",
    "supplier_id": "e9b30ab9-e3b0-4f8d-b845-805a6e0163f2",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.8",
          "1.16",
          "1.19"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.17",
          "2.18",
          "2.20",
          "2.22",
          "2.23",
          "2.24",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31"
        ]
      }
    ],
    "contact_name": "Andrew Imrie",
    "contact_email": "commercial@ardengemcsu.nhs.uk",
    "contact_phone": "0121 6110609"
  },
  {
    "supplier_name": "NHS NORTH OF ENGLAND CSU",
    "supplier_id": "8adce5bd-d8d0-4543-bce8-1b5e63d2488d",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.23",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.14",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.24"
        ]
      }
    ],
    "contact_name": "Brian Macgregor",
    "contact_email": "necsu.busdev@nhs.net",
    "contact_phone": "0191 3742715"
  },
  {
    "supplier_name": "NHS SHARED BUSINESS SERVICES LTD",
    "supplier_id": "34437205-3b52-440f-b137-155ee883b51a",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.6",
          "1.7",
          "1.8",
          "1.13",
          "1.15",
          "1.17",
          "1.18",
          "1.19",
          "1.21"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.31"
        ]
      }
    ],
    "contact_name": "Andrea Bird",
    "contact_email": "NSBS.Procurementinfo@nhs.net",
    "contact_phone": "0161 212 3714"
  },
  {
    "supplier_name": "NHS SOUTH, CENTRAL & WEST CSU",
    "supplier_id": "e9f0082f-ac5d-4b5e-b6e9-91fa1c31cf34",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.24"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.31"
        ]
      }
    ],
    "contact_name": "Faye Robinson",
    "contact_email": "scw.opportunities@nhs.net",
    "contact_phone": "02380 627444"
  },
  {
    "supplier_name": "NICHE STRATEGIC HEALTH PARTNERSHIP LTD",
    "supplier_id": "8f267d7c-2637-41ca-b3ac-7ddc2548038f",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22"
        ]
      }
    ],
    "contact_name": "Tom McCarthy",
    "contact_email": "susan.bagshaw@nicheconsult.co.uk",
    "contact_phone": "0161 785 1000"
  },
  {
    "supplier_name": "NORTH HIGHLAND UK LTD",
    "supplier_id": "5bd72923-a8f4-4761-8d12-c88dac19f99b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      }
    ],
    "contact_name": "Ben Grinnell",
    "contact_email": "nhuk.frameworks@northhighland.com",
    "contact_phone": "0207 8126460"
  },
  {
    "supplier_name": "NOUS GROUP UK LTD",
    "supplier_id": "c7211c3f-00db-4511-9e61-88c14e805075",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.25"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Bianca Panlook",
    "contact_email": "NousUK@nousgroup.com",
    "contact_phone": "0203 908 2080"
  },
  {
    "supplier_name": "NOVA AEROSPACE LTD",
    "supplier_id": "abfd7f62-0425-41d5-9d37-73d6592e1b91",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.30",
          "2.31"
        ]
      }
    ],
    "contact_name": "Philip Burton",
    "contact_email": "contact@novasystemsuk.com",
    "contact_phone": "0117 329 1550"
  },
  {
    "supplier_name": "NTT DATA UK LTD",
    "supplier_id": "2cf4fee6-b02b-4251-9dd0-61dfd12622bf",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.23",
          "1.24"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      }
    ],
    "contact_name": "Russell Wolak",
    "contact_email": "nttdatauk.requirements@nttdata.com",
    "contact_phone": "0777 585 3300"
  },
  {
    "supplier_name": "OAKLAND GROUP LLP",
    "supplier_id": "09f4ff29-350b-41a0-8a8b-bb4514e27578",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.11",
          "1.15",
          "1.16",
          "1.19",
          "1.20",
          "1.22"
        ]
      }
    ],
    "contact_name": "Simon Vear",
    "contact_email": "contactus@oaklandconsulting.com",
    "contact_phone": "0113 234 1944"
  },
  {
    "supplier_name": "OEE CONSULTING",
    "supplier_id": "d55d9565-c8f6-4889-ae96-f131ff23373c",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Martin Gibson",
    "contact_email": "info@oeeconsulting.com",
    "contact_phone": "01865 593911"
  },
  {
    "supplier_name": "OLM SYSTEMS LTD",
    "supplier_id": "6e3f765b-ac9e-44e6-a00d-fa874abb6d9e",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.11",
          "1.16",
          "1.19"
        ]
      }
    ],
    "contact_name": "Sam Newman",
    "contact_email": "contracts@partners4change.co.uk",
    "contact_phone": "07967 509057"
  },
  {
    "supplier_name": "ONARACH LTD",
    "supplier_id": "fd18f743-0987-4464-8ecd-748933f8cd23",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Jamie Bliss",
    "contact_email": "enquiries@onarach.com",
    "contact_phone": "0141 6288805"
  },
  {
    "supplier_name": "OVE ARUP & PARTNERS LTD",
    "supplier_id": "a1dc1523-0712-4db7-81b8-b97058851a43",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Liz Pattison",
    "contact_email": "procurement@arup.com",
    "contact_phone": "0121 213 3602"
  },
  {
    "supplier_name": "P2CG LTD",
    "supplier_id": "7d487e15-4d09-4145-99ac-f712c6c4eef8",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.4",
          "1.8",
          "1.9",
          "1.11",
          "1.19",
          "1.20",
          "1.24"
        ]
      }
    ],
    "contact_name": "Alastair Vetch",
    "contact_email": "bidmanagement@p2consulting.com",
    "contact_phone": "020 3823 2180"
  },
  {
    "supplier_name": "P2G CONTRACT SUPPORT LLP",
    "supplier_id": "cbbe609b-dfe3-43df-9f12-7c81c2f5e83d",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.7",
          "1.8",
          "1.9",
          "1.18",
          "1.19"
        ]
      }
    ],
    "contact_name": "Russell Manley",
    "contact_email": "russell@p-2-g.co.uk",
    "contact_phone": "07939 415679"
  },
  {
    "supplier_name": "PA CONSULTING SERVICES LTD",
    "supplier_id": "e6b50e22-9d8d-46e0-ae48-951e5e860061",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Lia Shaw",
    "contact_email": "mcf2@paconsulting.com",
    "contact_phone": "020 7333 5398"
  },
  {
    "supplier_name": "PANLOGIC LTD",
    "supplier_id": "07c410ea-6e57-4f5a-9d3d-b85f3bd507ec",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "William Makower",
    "contact_email": "contracts@panlogic.co.uk",
    "contact_phone": "0208 9485511"
  },
  {
    "supplier_name": "PARITY CONSULTANCY SERVICES LTD",
    "supplier_id": "0beef33a-9824-4ee0-87f1-825deae029f2",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Andrew Ogg",
    "contact_email": "pcstenders@parity.net",
    "contact_phone": "0208 171 1729"
  },
  {
    "supplier_name": "PARTNERS IN PERFORMANCE UK LTD",
    "supplier_id": "e23dca0b-c52f-4ade-88e6-a539e12ba965",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.8",
          "1.9",
          "1.11",
          "1.17",
          "1.19",
          "1.23"
        ]
      }
    ],
    "contact_name": "Guy Turner",
    "contact_email": "sales@pipint.com",
    "contact_phone": "07867 516866"
  },
  {
    "supplier_name": "PATHFINDER EXECUTION LTD",
    "supplier_id": "6c6f148a-ee0c-4902-a020-68ec61742db6",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.3",
          "1.6",
          "1.8",
          "1.11",
          "1.14",
          "1.15",
          "1.17",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.24"
        ]
      }
    ],
    "contact_name": "Alastair Geddes",
    "contact_email": "opendoor@pathfinder.co.uk",
    "contact_phone": "03531 9108908"
  },
  {
    "supplier_name": "PEKG LTD",
    "supplier_id": "a556e590-749f-4bc3-8723-7635618e27ac",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.3",
          "1.8",
          "1.11",
          "1.12",
          "1.17",
          "1.19",
          "1.20",
          "1.21",
          "1.22"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.6",
          "2.8",
          "2.12",
          "2.13",
          "2.15",
          "2.16",
          "2.20",
          "2.21",
          "2.23",
          "2.24",
          "2.25",
          "2.27",
          "2.29",
          "2.30",
          "2.31"
        ]
      }
    ]
  },
  {
    "supplier_name": "PENSPEN LTD",
    "supplier_id": "151dd033-c53e-4971-a8b1-a8c4a8160a30",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Noel Cunningham",
    "contact_email": "info@penspen.com",
    "contact_phone": "0208 3342700"
  },
  {
    "supplier_name": "PEOPLETOO LTD",
    "supplier_id": "a0312463-0136-41d6-92e2-75167ab9bc18",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.6",
          "2.8",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Michael Curnow",
    "contact_email": "procurement@peopletoo.co.uk",
    "contact_phone": "07825 115021"
  },
  {
    "supplier_name": "PERFORM GREEN LTD",
    "supplier_id": "152389a0-2a01-4f88-92b4-1c507b3a35fa",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Richard Barrington",
    "contact_email": "info@performgreen.co.uk",
    "contact_phone": " 01242 964032"
  },
  {
    "supplier_name": "PERSPECTIVE ECONOMICS LTD",
    "supplier_id": "c81a2d28-c0a3-4359-bc29-59961a6698da",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.18"
        ]
      }
    ],
    "contact_name": "Jonathan Hobson",
    "contact_email": "jh@perspectiveeconomics.com",
    "contact_phone": "07738 018545"
  },
  {
    "supplier_name": "PHILIPS ELECTRONICS UK LTD",
    "supplier_id": "ae9e7fac-3d67-4e8b-8167-b44f2cf284e0",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.11",
          "1.16"
        ]
      }
    ],
    "contact_name": "Peadar O''Mordha",
    "contact_email": "business.support@philips.com",
    "contact_phone": "07710 473943"
  },
  {
    "supplier_name": "PLACE GROUP LTD",
    "supplier_id": "a9e2455e-ecbd-45a4-90ea-6b5e73e43c65",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.23"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.29"
        ]
      }
    ],
    "contact_name": "Claire Delaney",
    "contact_email": "info@schoolsbuyingclub.com",
    "contact_phone": "0845 2577050"
  },
  {
    "supplier_name": "PREDERI LTD",
    "supplier_id": "5b40965b-c3dc-4758-b52d-8284b805dda6",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23"
        ]
      }
    ],
    "contact_name": "Stewart Johns",
    "contact_email": "bid@prederi.com",
    "contact_phone": "07711 685 108"
  },
  {
    "supplier_name": "PREMIER ADVISORY GROUP LTD",
    "supplier_id": "56127924-3182-423e-8d0c-dab77ff25c74",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.4",
          "1.6",
          "1.8",
          "1.10",
          "1.19"
        ]
      }
    ],
    "contact_name": "Tom Legge",
    "contact_email": "tom@premieradvisory.co.uk",
    "contact_phone": "07951 858666"
  },
  {
    "supplier_name": "PRICEWATERHOUSECOOPERS LLP",
    "supplier_id": "ec10af2d-54c9-4a31-a8c8-5ee83162e185",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Mary Patterson",
    "contact_email": "pwctenders@uk.pwc.com",
    "contact_phone": "02890 415101"
  },
  {
    "supplier_name": "PRIVATE PUBLIC LTD",
    "supplier_id": "6009b02f-73e5-4363-a031-b866eb3cbab1",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Ken Yeung",
    "contact_email": "ccs@pplconsulting.co.uk",
    "contact_phone": "020 7692 4851"
  },
  {
    "supplier_name": "PROGRAM PLANNING PROFESSIONALS LTD",
    "supplier_id": "927d74be-bacd-4ef4-a717-2ef774b46636",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      }
    ],
    "contact_name": "Mark Sorrell",
    "contact_email": "uk.info@pcubed.com",
    "contact_phone": "0207 462 0100"
  },
  {
    "supplier_name": "PROMOTE CONSULTING LTD",
    "supplier_id": "c8d9c8f9-5244-4c8c-88e1-ad49c871a111",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22"
        ]
      }
    ],
    "contact_name": "Rory Grumley",
    "contact_email": "admin@promote.consulting",
    "contact_phone": "07962 364506"
  },
  {
    "supplier_name": "PROTIVITI LTD",
    "supplier_id": "c804cb91-41af-40b8-96dd-17e57d82428a",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Sukhdev Bal",
    "contact_email": "sukhdev.bal@protiviti.co.uk",
    "contact_phone": "0207 024 7512"
  },
  {
    "supplier_name": "PUBLIC CONSULTING GROUP UK LTD",
    "supplier_id": "0a6e1d57-ce97-4518-bbc4-77a6beeddc2f",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.11",
          "1.13",
          "1.16"
        ]
      }
    ],
    "contact_name": "Agata Miskowiec",
    "contact_email": "tenders@publicconsultinggroup.co.uk",
    "contact_phone": "0333 600 6330"
  },
  {
    "supplier_name": "Q5 PARTNERS LLP",
    "supplier_id": "3747918b-bc46-48b2-8df8-af9714592724",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.18",
          "1.19",
          "1.20"
        ]
      }
    ],
    "contact_name": "Peter Horne",
    "contact_email": "pnfp@q5partners.com",
    "contact_phone": "0207 3400660"
  },
  {
    "supplier_name": "QE FACILITIES LTD",
    "supplier_id": "53c6df47-5627-40ef-bec2-75b9f9089652",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22",
          "1.24"
        ]
      }
    ],
    "contact_name": "Mr Rob Anderson",
    "contact_email": "ghnt.qeintegratedsolutions.enquires@nhs.net",
    "contact_phone": "0191 4454254"
  },
  {
    "supplier_name": "QINETIQ LTD",
    "supplier_id": "25ef04a7-e04d-4c00-9204-a0a04308424c",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.3",
          "1.8",
          "1.9",
          "1.10",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.3",
          "2.4",
          "2.8",
          "2.11",
          "2.12",
          "2.18",
          "2.20",
          "2.21",
          "2.23"
        ]
      }
    ],
    "contact_name": "Gavin Arnett",
    "contact_email": "OST@QinetiQ.com",
    "contact_phone": "01684 543800"
  },
  {
    "supplier_name": "QMPF LLP",
    "supplier_id": "b21e2138-2080-416d-b0a4-343a35815c83",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1"
        ]
      }
    ],
    "contact_name": "Stephen Bell",
    "contact_email": "info@qmpf.co.uk",
    "contact_phone": "0131 2222600"
  },
  {
    "supplier_name": "QUO IMUS LTD",
    "supplier_id": "ab005891-9447-4b8b-96d9-202b8ca1d091",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.24"
        ]
      }
    ],
    "contact_name": "Nicola Innes",
    "contact_email": "servicemanage@qi-consulting.co.uk",
    "contact_phone": "0207 793 4147"
  },
  {
    "supplier_name": "RAINMAKER SOLUTIONS LTD",
    "supplier_id": "51fe2cb2-aced-4e05-b16d-5cab0a387a48",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.25"
        ]
      }
    ],
    "contact_name": "Tim Hanley",
    "contact_email": "tenders@rainmaker.solutions",
    "contact_phone": "07966 272 402"
  },
  {
    "supplier_name": "RAYTHEON SYSTEMS LTD",
    "supplier_id": "a1445cad-670a-47c5-b83f-5287ad8254e8",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.8",
          "1.9",
          "1.10",
          "1.13",
          "1.15",
          "1.19",
          "1.20",
          "1.21"
        ]
      }
    ],
    "contact_name": "Michael Armstrong",
    "contact_email": "Tenders@raytheon.co.uk",
    "contact_phone": "07584 547970"
  },
  {
    "supplier_name": "REDESMERE LTD",
    "supplier_id": "22e64fec-c531-4318-ab12-ca5e1b8a0c15",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20"
        ]
      }
    ],
    "contact_name": "Richard Porter",
    "contact_email": "contact@redesmere.com",
    "contact_phone": "07880 780000"
  },
  {
    "supplier_name": "REDQUADRANT LTD",
    "supplier_id": "59743df8-e915-47d8-af0e-aa1e5417420a",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24"
        ]
      }
    ],
    "contact_name": "Benjamin Taylor",
    "contact_email": "MCF2@redquadrant.com",
    "contact_phone": "07931 317230"
  },
  {
    "supplier_name": "REED PROFESSIONAL SERVICES LLP",
    "supplier_id": "df4d4581-cb07-4011-949e-65f3fd0728f1",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "John Vaughan",
    "contact_email": "ccs@reedps.com"
  },
  {
    "supplier_name": "RENAISI LTD",
    "supplier_id": "8001c67e-8471-4b4a-ba0b-8257f44a1994",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20"
        ]
      }
    ],
    "contact_name": "Michael Toyer",
    "contact_email": "tenders@renaisi.com",
    "contact_phone": "0207 0332614"
  },
  {
    "supplier_name": "REPLY LTD",
    "supplier_id": "abb88200-5af4-4488-b676-7f65d9bcd127",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.8",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "James Giggins",
    "contact_email": "glue@reply.com",
    "contact_phone": "0207 7306000"
  },
  {
    "supplier_name": "RICHARD ACZEL LTD",
    "supplier_id": "07db9636-5e70-4691-be2c-0482c8be4c4d",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.11",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Jayne Santacana",
    "contact_email": "info@aczel.org",
    "contact_phone": "07584 199094‬"
  },
  {
    "supplier_name": "RIDER LEVETT BUCKNALL UK LTD",
    "supplier_id": "2485c607-be8e-48b0-9f92-75d033d7b7f2",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Andrew Reynolds",
    "contact_email": "ccs@uk.rlb.com",
    "contact_phone": "0207 398 8300"
  },
  {
    "supplier_name": "RISK & POLICY ANALYSTS LTD",
    "supplier_id": "bb95cec7-addc-4515-8c92-7491dcdd51b7",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.10",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.25"
        ]
      }
    ],
    "contact_name": "Matthew Lambert",
    "contact_email": "post@rpaltd.co.uk",
    "contact_phone": "01508 528465"
  },
  {
    "supplier_name": "RISKSOL CONSULTING LTD",
    "supplier_id": "7edf54c0-3ed4-423e-8fdd-d496eadd6f06",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.12",
          "1.14",
          "1.15",
          "1.17",
          "1.18",
          "1.20",
          "1.22"
        ]
      }
    ],
    "contact_name": "Helen Wilkinson",
    "contact_email": "tracker@risksol.co.uk",
    "contact_phone": "01926 41 3984"
  },
  {
    "supplier_name": "ROTHWELL TO THE POINT LTD",
    "supplier_id": "f9ddb399-3519-4c20-b442-6f8433d5239c",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.4",
          "1.5",
          "1.6",
          "1.8",
          "1.12",
          "1.16",
          "1.18"
        ]
      }
    ],
    "contact_name": "Sandra Rothwell",
    "contact_email": "hello@rothwellpoint.com",
    "contact_phone": "07580 710937"
  },
  {
    "supplier_name": "RSM UK TAX & ACCOUNTING LTD",
    "supplier_id": "6082d496-ee3b-4ad9-a8b2-0fb4ce8ea5a9",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.8",
          "1.11",
          "1.12",
          "1.16",
          "1.17",
          "1.18",
          "1.19"
        ]
      }
    ],
    "contact_name": "Kat Styler",
    "contact_email": "bidteam@rsmuk.com",
    "contact_phone": "0121 214 3322"
  },
  {
    "supplier_name": "SA GROUP LTD",
    "supplier_id": "3ee61e5b-85a1-43ba-96dd-76d1cfca1302",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.5",
          "1.6",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Owen Gudge",
    "contact_email": "commercial@sa-group.com",
    "contact_phone": "07903 928710"
  },
  {
    "supplier_name": "SC SKILLS LTD",
    "supplier_id": "8491015f-8d1b-4a08-aeee-73f74dc9fec0",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.25"
        ]
      }
    ],
    "contact_name": "Gerald Hogg",
    "contact_email": "info@sc-skills.com",
    "contact_phone": "0203 9495570"
  },
  {
    "supplier_name": "SERCO LTD",
    "supplier_id": "86f6b727-34ce-4413-a32b-13cfc1064320",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.23"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      }
    ],
    "contact_name": "Mitesh Amin",
    "contact_email": "frameworks@serco.com",
    "contact_phone": "01256 745900"
  },
  {
    "supplier_name": "SLR CONSULTING LTD",
    "supplier_id": "489c22d8-687c-4023-84a5-23adbd8f72d6",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.17",
          "1.18",
          "1.20",
          "1.21"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.6",
          "2.8",
          "2.10",
          "2.11",
          "2.12",
          "2.15",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.25",
          "2.27",
          "2.31"
        ]
      }
    ],
    "contact_name": "Gary Armstrong",
    "contact_email": "enquiries@slrconsulting.com",
    "contact_phone": "0161 872 7564"
  },
  {
    "supplier_name": "SMART CONSULT LTD",
    "supplier_id": "70aa6a86-e6d3-4f89-b48b-a80b68542522",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.19",
          "1.20",
          "1.21",
          "1.22"
        ]
      }
    ],
    "contact_name": "Kevin Sharpe",
    "contact_email": "procurement@smart-investment.net",
    "contact_phone": "0203 7443870"
  },
  {
    "supplier_name": "SOCIAL FINANCE LTD",
    "supplier_id": "f362396b-8f09-4def-9981-b45642b7db5d",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Robert Pollock",
    "contact_email": "tenders@socialfinance.org.uk",
    "contact_phone": "02076 676375"
  },
  {
    "supplier_name": "SOCITM LTD",
    "supplier_id": "6785bde8-c9a0-416f-8802-10c835fde054",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.24"
        ]
      }
    ],
    "contact_name": "Tony Summers",
    "contact_email": "advisory@socitm.net",
    "contact_phone": "07889 181736"
  },
  {
    "supplier_name": "SOLSUS LTD",
    "supplier_id": "2097eddd-af8a-4b53-9a4d-945b558ee8b9",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.7",
          "1.8",
          "1.13",
          "1.18",
          "1.19"
        ]
      }
    ],
    "contact_name": "James Gooding",
    "contact_email": "jwg@solsus.com",
    "contact_phone": "07968 244292"
  },
  {
    "supplier_name": "SOPRA STERIA LTD",
    "supplier_id": "a72c5ac6-b4ec-41f0-b105-ccf7c68fc212",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Suzanne Angell",
    "contact_email": "sector-support@soprasteria.com"
  },
  {
    "supplier_name": "SPORTING ASSETS LTD",
    "supplier_id": "d76efc29-fecd-4ed6-94bb-0f127f532953",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.21"
        ]
      }
    ],
    "contact_name": "Paul Ebied",
    "contact_email": "enquiries@sportingassets.co.uk",
    "contact_phone": "0203 637 2924"
  },
  {
    "supplier_name": "ST VINCENT''S HEALTH & PUBLIC SECTOR CONSULTING LTD",
    "supplier_id": "08320812-a4b1-408a-8e26-f555889b78e4",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.6",
          "1.8",
          "1.11",
          "1.15",
          "1.16",
          "1.17",
          "1.19"
        ]
      }
    ],
    "contact_name": "Seonaid McGinn",
    "contact_email": "info@stvincentsconsulting.com",
    "contact_phone": "07525 643504"
  },
  {
    "supplier_name": "STATE OF FLUX LTD",
    "supplier_id": "18d3a679-13fd-410d-b877-e6f63791fa76",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.10",
          "1.15",
          "1.19",
          "1.20",
          "1.21",
          "1.22"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.31"
        ]
      }
    ],
    "contact_name": "Mel Shutes",
    "contact_email": "enquiries@stateofflux.co.uk",
    "contact_phone": "0207 8420600"
  },
  {
    "supplier_name": "STRATEGIC HEALTHCARE PLANNING LLP",
    "supplier_id": "e309497e-9dc9-42cd-b4c2-d81dc169295e",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.17"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.11",
          "2.20",
          "2.21"
        ]
      }
    ],
    "contact_name": "Jeremy Cox",
    "contact_email": "info@shp-uk.com",
    "contact_phone": "01952 677660"
  },
  {
    "supplier_name": "SYNTEL EUROPE LTD",
    "supplier_id": "2f7a5601-6677-404b-98aa-162261bfecad",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.5",
          "1.8",
          "1.9",
          "1.10",
          "1.12",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20",
          "1.22",
          "1.25"
        ]
      }
    ],
    "contact_name": "Rajiv Malhotra",
    "contact_email": "PublicSector_Sales@Syntelinc.com",
    "contact_phone": "0790 362 7289"
  },
  {
    "supplier_name": "SYSDOC LTD",
    "supplier_id": "0f22646b-983e-49b7-9f65-a63fa1591932",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.9",
          "2.13",
          "2.14",
          "2.16",
          "2.17",
          "2.21",
          "2.25",
          "2.28",
          "2.32"
        ]
      }
    ],
    "contact_name": "Simon Niven",
    "contact_email": "business.development@sysdoc.co.uk",
    "contact_phone": "0203 0024825"
  },
  {
    "supplier_name": "TEAM CONSULTING INTERNATIONAL (UK) LTD",
    "supplier_id": "ee435b1c-d2f5-46d2-82cf-5bf1e8eaa284",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ]
  },
  {
    "supplier_name": "TECHMODAL LTD",
    "supplier_id": "c65b710e-8bc5-4ec0-93c2-451e16c14c2b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.13",
          "1.15",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.3",
          "2.4",
          "2.6",
          "2.8",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.17",
          "2.18",
          "2.20",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Amanda Clapp",
    "contact_email": "tenders@techmodal.com",
    "contact_phone": "0117 376 3477"
  },
  {
    "supplier_name": "TENEO BUSINESS CONSULTING LTD",
    "supplier_id": "39c5bf98-a42d-4203-89b9-2023b0355d3b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.23",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.8",
          "2.9",
          "2.11",
          "2.14",
          "2.15",
          "2.17",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Leo van der Borgh",
    "contact_email": "accounts@teneoconsult.com",
    "contact_phone": "0203 2068800"
  },
  {
    "supplier_name": "TENWELL INNOVATIONS LTD",
    "supplier_id": "d29d84a7-e0e3-4d55-a524-5a2f8c9d3ab7",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Nicky Hay",
    "contact_email": "info@ecovategroup.com",
    "contact_phone": "0207 558 8875"
  },
  {
    "supplier_name": "THALES UK LTD",
    "supplier_id": "dceae025-05cd-4ddc-91cc-b33cf235e862",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.9",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.23",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Margaret Shay",
    "contact_email": "fcmo@uk.thalesgroup.com",
    "contact_phone": "07966 363487"
  },
  {
    "supplier_name": "THE BERKELEY PARTNERSHIP LLP",
    "supplier_id": "a8c5ed5b-b310-44c0-9d98-3c02355f572b",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.25"
        ]
      }
    ],
    "contact_name": "Holly Hull",
    "contact_email": "BD&Quality@berkeleypartnership.com",
    "contact_phone": "0207 643 5800"
  },
  {
    "supplier_name": "THE BOSTON CONSULTING GROUP UK LLP",
    "supplier_id": "491fae10-cc6a-4f6c-90a4-042152115bdc",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.17",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Patrick Roche",
    "contact_email": "publicsectoruk@bcg.com",
    "contact_phone": "0203 140 0836"
  },
  {
    "supplier_name": "THE DMW GROUP LTD",
    "supplier_id": "51b66b69-4326-48d1-963a-8c802f99476f",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.21",
          "1.24"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.12",
          "2.14",
          "2.20",
          "2.21",
          "2.24",
          "2.25",
          "2.27"
        ]
      }
    ],
    "contact_name": "Graham Hall",
    "contact_email": "dmwpublicsector@dmwgroup.co.uk",
    "contact_phone": "020 3198 4934"
  },
  {
    "supplier_name": "THE LITMUS PARTNERSHIP LTD",
    "supplier_id": "4e6f5be1-45c2-4f52-a31a-58d1dda4d454",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.7",
          "1.9",
          "1.17",
          "1.19"
        ]
      }
    ],
    "contact_name": "Katie Foster",
    "contact_email": "admin@litmuspartnership.co.uk",
    "contact_phone": "01276 673891"
  },
  {
    "supplier_name": "THE NICHOLS GROUP LTD",
    "supplier_id": "d1932ee8-68a8-44aa-bbd6-e852a5ade17e",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.12",
          "1.13",
          "1.14",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Lynn Mackenzie",
    "contact_email": "operations@nichols.uk.com"
  },
  {
    "supplier_name": "THE RETEARN GROUP LTD",
    "supplier_id": "890f4dd0-d970-4706-a79c-614304a6b418",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Mark Wyllie",
    "contact_email": "business.development@retearn.co.uk",
    "contact_phone": "01344 874 707"
  },
  {
    "supplier_name": "TP GROUP PLC",
    "supplier_id": "b38ab7d4-8877-4f12-81c8-0c51b0d8fe88",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.8",
          "1.13",
          "1.15",
          "1.16",
          "1.19",
          "1.20",
          "1.22"
        ]
      }
    ],
    "contact_name": "Andy Howard",
    "contact_email": "frameworks@tpgroup.uk.com",
    "contact_phone": "01753 285800"
  },
  {
    "supplier_name": "TRANSFORMATION NOUS LTD",
    "supplier_id": "5acafa0c-2658-40d3-a644-3789b3e7e2ff",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.8",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Andreas Hadjitheoris",
    "contact_email": "info@transformation-nous.com",
    "contact_phone": "07500 607434"
  },
  {
    "supplier_name": "TRAVERSUM LTD",
    "supplier_id": "5ec6f64b-e2e0-4ab1-a60b-a18732036ca3",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.6",
          "1.8",
          "1.11",
          "1.13",
          "1.16",
          "1.17",
          "1.19"
        ]
      }
    ],
    "contact_name": "Greg Wilkinson",
    "contact_email": "contact@traversum.co.uk",
    "contact_phone": "07701 338606"
  },
  {
    "supplier_name": "TRICORDANT LTD",
    "supplier_id": "49239a5c-1144-4dd8-b2b3-2f8bc1ebd4e2",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.19"
        ]
      }
    ],
    "contact_name": "John Taylor",
    "contact_email": "office@tricordant.com",
    "contact_phone": "07725 813062"
  },
  {
    "supplier_name": "TURNER & TOWNSEND CONSULTING LTD",
    "supplier_id": "52709854-7ae6-4982-ae14-595b2b0ec8df",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.24",
          "1.25"
        ]
      }
    ],
    "contact_name": "Gary Healey",
    "contact_email": "CCSMCF2Lot1@turntown.com",
    "contact_phone": "020 7544 4000"
  },
  {
    "supplier_name": "TWS PARTNERS LTD",
    "supplier_id": "2fbc8fbb-f558-4fe1-a00e-7f1dee461d46",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.6",
          "1.7",
          "1.16",
          "1.18",
          "1.19"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.4",
          "2.5",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.16",
          "2.17",
          "2.18",
          "2.21",
          "2.24",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Daniel Wagner",
    "contact_email": "info@tws-partners.com",
    "contact_phone": "0203 5804276"
  },
  {
    "supplier_name": "UNIPART LOGISTICS LTD",
    "supplier_id": "a3cb41c8-0e73-4a20-b256-79ffb11645fe",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.2",
          "1.3",
          "1.8",
          "1.19",
          "1.25"
        ]
      }
    ],
    "contact_name": "Steve Morris",
    "contact_email": "hello@unipart.com",
    "contact_phone": "07825 192857"
  },
  {
    "supplier_name": "V4 SERVICES LTD",
    "supplier_id": "c232a0cc-3d83-4988-bc42-6dcd63e1fee0",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.20"
        ]
      }
    ],
    "contact_name": "Rachel Frondigoun",
    "contact_email": "tenders@v4services.com",
    "contact_phone": "0121 400 0408"
  },
  {
    "supplier_name": "VENDIGITAL LTD",
    "supplier_id": "92be0aa2-42ef-4fe3-9fd4-0e2c425f2ed9",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.13",
          "1.15",
          "1.19",
          "1.20"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Paul Adams",
    "contact_email": "info@vendigital.com",
    "contact_phone": "01793 441410"
  },
  {
    "supplier_name": "VERACITY OSI UK LTD",
    "supplier_id": "f6b84e95-ef65-45b1-b797-9bb8e5f9d8fe",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.6",
          "2.7",
          "2.8",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.7",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Satinder Sembi",
    "contact_email": "tenders@veracityconsulting.co.uk",
    "contact_phone": "07980 871935"
  },
  {
    "supplier_name": "VERAN PERFORMANCE LTD",
    "supplier_id": "ef70513d-71c7-430a-afdb-1f912f77862c",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23"
        ]
      }
    ],
    "contact_name": "Helena Sedgwick",
    "contact_email": "contact@veranperformance.com",
    "contact_phone": "07929 797504"
  },
  {
    "supplier_name": "WHITE SPACE STRATEGY LTD",
    "supplier_id": "c10f8ddb-f33b-4c28-85ec-d45b096daf96",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.4",
          "1.6",
          "1.11",
          "1.13",
          "1.16",
          "1.17",
          "1.25"
        ]
      }
    ],
    "contact_name": "Sarosh Khan",
    "contact_email": "info@whitespacestrategy.com",
    "contact_phone": "01865 793800"
  },
  {
    "supplier_name": "WHITECAP CONSULTING LTD",
    "supplier_id": "b8572afe-f3cd-47b8-8ecd-a104a943fed7",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.11",
          "1.13",
          "1.15",
          "1.16",
          "1.17",
          "1.19",
          "1.23",
          "1.25"
        ]
      }
    ],
    "contact_name": "Stefan Haase",
    "contact_email": "info@whitecapconsulting.co.uk",
    "contact_phone": "0113 834 3133"
  },
  {
    "supplier_name": "XOOMWORKS LTD",
    "supplier_id": "65690fd7-f8c6-4fbe-a6fe-8c1dc0dc0c96",
    "lots": [
      {
        "lot_number": "1",
        "services": [
          "1.1",
          "1.2",
          "1.3",
          "1.4",
          "1.5",
          "1.6",
          "1.7",
          "1.8",
          "1.9",
          "1.10",
          "1.11",
          "1.12",
          "1.13",
          "1.14",
          "1.15",
          "1.16",
          "1.17",
          "1.18",
          "1.19",
          "1.20",
          "1.21",
          "1.22",
          "1.23",
          "1.24",
          "1.25"
        ]
      },
      {
        "lot_number": "2",
        "services": [
          "2.4",
          "2.5",
          "2.10",
          "2.12",
          "2.16",
          "2.18",
          "2.28"
        ]
      }
    ],
    "contact_name": "Neil Patterson",
    "contact_email": "Procurement@xoomworks.com",
    "contact_phone": "07976 634501"
  },
  {
    "supplier_name": "AMBERSIDE ADVISORS LTD",
    "supplier_id": "185d3b03-60d5-461c-a1a3-98317dbfb5d5",
    "lots": [
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.29",
          "2.30",
          "2.31"
        ]
      }
    ],
    "contact_name": "Debra Secunda",
    "contact_email": "debra.secunda@amberside.uk",
    "contact_phone": "07983 598 894"
  },
  {
    "supplier_name": "AYMING UK LTD",
    "supplier_id": "094a8d29-7ab4-4b43-b6d5-73944dcd7c9a",
    "lots": [
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.27",
          "2.28",
          "2.29",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Alejandro Alvarez",
    "contact_email": "uktenders@ayming.com",
    "contact_phone": "0203 058 58 00"
  },
  {
    "supplier_name": "CRIMSON CONSULTING (UK) LTD",
    "supplier_id": "dc35c0b6-5fbc-41c4-869e-4c86e4eb78e3",
    "lots": [
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Nick Miller",
    "contact_email": "information@crimsonandco.com",
    "contact_phone": "07747 470610"
  },
  {
    "supplier_name": "EFFICIO LTD",
    "supplier_id": "541f3d08-b459-4e79-8dad-226ed48f2ec9",
    "lots": [
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Ian McNally",
    "contact_email": "info@efficioconsulting.com",
    "contact_phone": "07738 184268"
  },
  {
    "supplier_name": "EXPENSE REDUCTION ANALYSTS (UK) LTD",
    "supplier_id": "be98ba42-2592-44ca-bf97-06e461857141",
    "lots": [
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Julian Mobbs",
    "contact_email": "info@expense-reduction.co.uk",
    "contact_phone": "01732 525 850"
  },
  {
    "supplier_name": "GARDINER & THEOBALD LLP",
    "supplier_id": "5a2a4527-9262-4f18-95f7-cde4deeba063",
    "lots": [
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Peter Sell",
    "contact_email": "S.Mills@Gardiner.com",
    "contact_phone": "07712 865 607"
  },
  {
    "supplier_name": "INFRASTRUCTURE ADVISORY UK LTD",
    "supplier_id": "e20ae7d0-3ddd-4d82-82d7-0018379884b5",
    "lots": [
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.4",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.18",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.25",
          "2.26",
          "2.27",
          "2.29",
          "2.30"
        ]
      }
    ],
    "contact_name": "Christopher Johnson",
    "contact_email": "info@infrauk.com",
    "contact_phone": "07805 197085"
  },
  {
    "supplier_name": "LAKESMITH CONSULTING LTD",
    "supplier_id": "e8b4cea5-b7a6-40af-9c9e-4b2eab66ad97",
    "lots": [
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.4",
          "2.5",
          "2.7",
          "2.8",
          "2.9",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.16",
          "2.18",
          "2.21",
          "2.22",
          "2.24",
          "2.25",
          "2.27",
          "2.28",
          "2.29"
        ]
      }
    ],
    "contact_name": "Pav Lalli",
    "contact_email": "info@lakesmithconsulting.com"
  },
  {
    "supplier_name": "LONG O DONNELL ASSOCIATES LTD",
    "supplier_id": "e2be8615-e923-4ce9-b204-7f879c06f235",
    "lots": [
      {
        "lot_number": "2",
        "services": [
          "2.2",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.11",
          "2.13",
          "2.15",
          "2.16",
          "2.18",
          "2.21",
          "2.23",
          "2.24",
          "2.27",
          "2.30",
          "2.31"
        ]
      }
    ],
    "contact_name": "Mark Jackson",
    "contact_email": "bidteam@long-odonnell.com",
    "contact_phone": "01606 359 200"
  },
  {
    "supplier_name": "ODESMA LTD",
    "supplier_id": "00e12e17-c1bc-4299-b715-3e9f3c5564a2",
    "lots": [
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.16",
          "2.17",
          "2.18",
          "2.20",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31"
        ]
      }
    ],
    "contact_name": "Nick Ford",
    "contact_email": "contact@odesma.co.uk",
    "contact_phone": "07500 121873"
  },
  {
    "supplier_name": "PROCURA CONSULTING LTD",
    "supplier_id": "9f762f17-ee78-465e-8207-62d52dd94795",
    "lots": [
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.17",
          "2.18",
          "2.20",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.29",
          "2.31",
          "2.32"
        ]
      }
    ],
    "contact_name": "Philip Finch",
    "contact_email": "info@procuraconsulting.co.uk",
    "contact_phone": "0203 693 7275"
  },
  {
    "supplier_name": "TURNER & TOWNSEND CONTRACT SERVICES LTD",
    "supplier_id": "bb4d0634-f8be-4243-b452-60d1b00b24d1",
    "lots": [
      {
        "lot_number": "2",
        "services": [
          "2.1",
          "2.2",
          "2.3",
          "2.4",
          "2.5",
          "2.6",
          "2.7",
          "2.8",
          "2.9",
          "2.10",
          "2.11",
          "2.12",
          "2.13",
          "2.14",
          "2.15",
          "2.17",
          "2.18",
          "2.19",
          "2.20",
          "2.21",
          "2.22",
          "2.23",
          "2.24",
          "2.25",
          "2.26",
          "2.27",
          "2.28",
          "2.29",
          "2.30",
          "2.31"
        ]
      }
    ],
    "contact_name": "Romi Alboreto",
    "contact_email": "CCSMCF2Lot2@turntown.com",
    "contact_phone": "020 7544 4000"
  },
  {
    "supplier_name": "OLIVER WYMAN LTD",
    "supplier_id": "a4ac77c5-1219-4ac6-a8f5-634071955526",
    "lots": [
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      },
      {
        "lot_number": "4",
        "services": [
          "4.1",
          "4.2",
          "4.3",
          "4.4",
          "4.5",
          "4.6",
          "4.8",
          "4.9",
          "4.10",
          "4.11",
          "4.12",
          "4.13"
        ]
      }
    ],
    "contact_name": "Agata Gutowska",
    "contact_email": "public.tenders@oliverwyman.com",
    "contact_phone": "+48 (22) 3766269"
  },
  {
    "supplier_name": "TURNER & TOWNSEND PROJECT MANAGEMENT LTD",
    "supplier_id": "deb1e947-1a35-4816-b5f4-de3352f650d0",
    "lots": [
      {
        "lot_number": "3",
        "services": [
          "3.1",
          "3.2",
          "3.3",
          "3.4",
          "3.5",
          "3.6",
          "3.7",
          "3.8",
          "3.9",
          "3.10",
          "3.11",
          "3.12",
          "3.13",
          "3.14",
          "3.15"
        ]
      }
    ],
    "contact_name": "Bill McElroy",
    "contact_email": "CCSMCF2Lot3@turntown.co.uk",
    "contact_phone": "020 7544 4000"
  }
]
')

  end
end
