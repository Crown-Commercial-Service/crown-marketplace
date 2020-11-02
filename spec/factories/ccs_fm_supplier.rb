FactoryBot.define do
  factory :ccs_fm_supplier, class: CCS::FM::Supplier do
    id { SecureRandom.uuid }
    supplier_id { id }
    supplier_name { Faker::Name.unique.name }
    contact_email { Faker::Internet.unique.email }
  end

  factory :ccs_fm_supplier_with_lots, parent: :ccs_fm_supplier do
    lot_data do
      {
        '1a':
          {
            regions: %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1
                        UKG2 UKG3 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ4 UKK1 UKK2 UKL11 UKL17
                        UKL18 UKL21 UKL22 UKL23 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32
                        UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50],
            services: %w[A.7 A.12 A.9 A.5 A.2 A.1 A.3 A.11 A.6 A.16 A.13 A.10 A.8 A.15 A.4 A.18
                         A.14 A.17 B.1 C.21 C.15 C.10 C.11 C.14 C.3 C.4 C.13 C.7 C.5 C.20 C.17 C.1 C.18
                         C.9 C.8 C.6 C.22 C.12 C.16 C.2 C.19 D.6 D.1 D.5 D.3 D.4 D.2 E.1 E.9 E.5
                         E.6 E.7 E.8 E.4 E.3 E.2 F.1 F.2 F.3 F.4 F.5 F.6 F.7 F.8 F.9 F.10 G.8 G.13
                         G.5 G.2 G.4 G.10 G.11 G.16 G.14 G.3 G.15 G.9 G.1 G.12 G.7 G.6 H.16 H.9 H.12
                         H.7 H.3 H.10 H.4 H.2 H.1 H.5 H.15 H.6 H.13 H.8 H.11 H.14 I.3 I.1 I.2 I.4
                         J.8 J.2 J.3 J.4 J.9 J.10 J.11 J.6 J.1 J.5 J.12 J.7 K.1 K.5 K.7 K.2 K.4
                         K.6 K.3 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.9 L.10 L.11 M.1 N.1 O.1]
          },
        '1b':
          {
            regions: %w[UKC1 UKC2 UKD1 UKD3 UKD4 UKD6 UKD7 UKE1 UKE2 UKE3 UKE4 UKF1 UKF2 UKF3 UKG1
                        UKG2 UKG3 UKH2 UKH3 UKI3 UKI4 UKI5 UKI6 UKI7 UKJ1 UKJ2 UKJ4 UKK1 UKK2 UKL11 UKL17
                        UKL18 UKL21 UKL22 UKL23 UKM21 UKM22 UKM23 UKM24 UKM25 UKM26 UKM27 UKM28 UKM31 UKM32
                        UKM33 UKM34 UKM35 UKM36 UKM37 UKM38 UKM50],
            services: %w[A.7 A.12 A.9 A.5 A.2 A.1 A.3 A.11 A.6 A.16 A.13 A.10 A.8 A.15 A.4 A.18
                         A.14 A.17 B.1 C.21 C.15 C.10 C.11 C.14 C.3 C.4 C.13 C.7 C.5 C.20 C.17 C.1 C.18
                         C.9 C.8 C.6 C.22 C.12 C.16 C.2 C.19 D.6 D.1 D.5 D.3 D.4 D.2 E.1 E.9 E.5
                         E.6 E.7 E.8 E.4 E.3 E.2 F.1 F.2 F.3 F.4 F.5 F.6 F.7 F.8 F.9 F.10 G.8 G.13
                         G.5 G.2 G.4 G.10 G.11 G.16 G.14 G.3 G.15 G.9 G.1 G.12 G.7 G.6 H.16 H.9 H.12
                         H.7 H.3 H.10 H.4 H.2 H.1 H.5 H.15 H.6 H.13 H.8 H.11 H.14 I.3 I.1 I.2 I.4
                         J.8 J.2 J.3 J.4 J.9 J.10 J.11 J.6 J.1 J.5 J.12 J.7 K.1 K.5 K.7 K.2 K.4
                         K.6 K.3 L.1 L.2 L.3 L.4 L.5 L.6 L.7 L.8 L.9 L.10 L.11 M.1 N.1 O.1]
          }
      }
    end

    trait :with_supplier_name do
      transient do
        name { 'My supplier' }
      end
      after(:build) do |supplier, evaluator|
        supplier.supplier_name = evaluator.name
      end
    end
  end
end
