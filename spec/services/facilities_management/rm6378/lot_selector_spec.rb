require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::LotSelector do
  # rubocop:disable RSpec/NestedGroups
  describe '.select_lot_numbers lot numbers' do
    let(:result) { described_class.select_lot_numbers(service_numbers, annual_contract_value).lot_results.map { |lot_result| [lot_result.lot_number, lot_result.service_numbers] } }

    let(:annual_contract_value) { rand(2_000_000) }

    total_service_numbers = %w[O1 P1 P9]
    hard_service_numbers = %w[E1 F1 J20]
    soft_service_numbers = %w[G1 H3 I6]
    hard_and_soft_service_numbers = %w[J19 R1]
    security_officer_service_numbers = %w[S1 S2]
    security_systems_service_numbers = %w[T1 V1]
    security_officer_and_systems_service_numbers = %w[W1]
    security_advisory_service_numbers = %w[X1 Y1 Z1]

    context 'when only FM services are selected' do
      context 'when all services are hard' do
        let(:service_numbers) { hard_service_numbers }

        [
          [
            'less than 2,000,000',
            rand(2_000_000),
            '2a'
          ],
          [
            '2,000,000',
            2_000_000,
            '2a'
          ],
          [
            'a little more than 2,000,000',
            2_000_001,
            '2b'
          ],
          [
            'more than 2,000,000',
            rand(2_000_000...50_000_000),
            '2b'
          ],
        ].each do |example_name, example_annual_contract_value, expected_result|
          context "when the annual_contract_value is #{example_name}" do
            let(:annual_contract_value) { example_annual_contract_value }

            it "returns #{expected_result} with '#{hard_service_numbers.join(', ')}'" do
              expect(result).to eq [
                [
                  expected_result,
                  hard_service_numbers
                ]
              ]
            end
          end
        end
      end

      context 'when all services are soft' do
        let(:service_numbers) { soft_service_numbers }

        [
          [
            'less than 2,000,000',
            rand(2_000_000),
            '3a'
          ],
          [
            '2,000,000',
            2_000_000,
            '3a'
          ],
          [
            'a little more than 2,000,000',
            2_000_001,
            '3b'
          ],
          [
            'more than 2,000,000',
            rand(2_000_000...50_000_000),
            '3b'
          ],
        ].each do |example_name, example_annual_contract_value, expected_result|
          context "when the annual_contract_value is #{example_name}" do
            let(:annual_contract_value) { example_annual_contract_value }

            it "returns #{expected_result} with '#{soft_service_numbers.join(', ')}'" do
              expect(result).to eq [
                [
                  expected_result,
                  soft_service_numbers
                ]
              ]
            end
          end
        end
      end

      context 'when all services are just total' do
        let(:service_numbers) { total_service_numbers }

        [
          [
            'less than 2,000,000',
            rand(2_000_000),
            '1a'
          ],
          [
            '2,000,000',
            2_000_000,
            '1a'
          ],
          [
            'a little more than 2,000,000',
            2_000_001,
            '1b'
          ],
          [
            'a more than 2,000,000 and less than 15,000,000',
            rand(2_000_000...15_000_000),
            '1b'
          ],
          [
            '15,000,000',
            15_000_000,
            '1b'
          ],
          [
            'a little more than 15,000,000',
            15_000_001,
            '1c'
          ],
          [
            'more than 15,000,000',
            rand(15_000_000...50_000_000),
            '1c'
          ],
        ].each do |example_name, example_annual_contract_value, expected_result|
          context "when the annual_contract_value is #{example_name}" do
            let(:annual_contract_value) { example_annual_contract_value }

            it "returns #{expected_result} with '#{total_service_numbers.join(', ')}'" do
              expect(result).to eq [
                [
                  expected_result,
                  total_service_numbers
                ]
              ]
            end
          end
        end
      end

      context 'when considering CAFM' do
        context 'and the services are hard' do
          let(:service_numbers) { hard_service_numbers + ['Q2'] }

          it "returns 2a with '#{hard_service_numbers.join(', ')} and Q2'" do
            expect(result).to eq [
              [
                '2a',
                hard_service_numbers + ['Q2']
              ]
            ]
          end
        end

        context 'and the services are soft' do
          let(:service_numbers) { soft_service_numbers + ['Q2'] }

          it "returns 3a with '#{soft_service_numbers.join(', ')} and Q1'" do
            expect(result).to eq [
              [
                '3a',
                soft_service_numbers + ['Q1']
              ]
            ]
          end
        end

        context 'and the services are total' do
          let(:service_numbers) { total_service_numbers + ['Q2'] }

          it "returns 1a with '#{total_service_numbers.join(', ')} and Q2'" do
            expect(result).to eq [
              [
                '1a',
                total_service_numbers + ['Q2']
              ]
            ]
          end
        end
      end

      [
        [
          'hard services with some that are just total',
          hard_service_numbers + total_service_numbers,
          '1a'
        ],
        [
          'hard services with some that are total with soft',
          hard_service_numbers + hard_and_soft_service_numbers,
          '2a'
        ],
        [
          'soft services with some that are just total',
          soft_service_numbers + total_service_numbers,
          '1a'
        ],
        [
          'soft services with some that are total with hard',
          soft_service_numbers + hard_and_soft_service_numbers,
          '3a'
        ],
        [
          'total services with some that are hard and soft',
          total_service_numbers + hard_and_soft_service_numbers,
          '1a'
        ],
        [
          'soft and hard services',
          hard_service_numbers + soft_service_numbers,
          '1a'
        ],
        [
          'total services which are hard and soft',
          hard_and_soft_service_numbers,
          '1a'
        ],
        [
          'total services which are hard and soft with one hard service',
          hard_and_soft_service_numbers + ['E1'],
          '2a'
        ],
        [
          'total services which are hard and soft with one soft service',
          hard_and_soft_service_numbers + ['G1'],
          '3a'
        ],
      ].each do |example_name, example_service_numbers, expected_result|
        context "when there are #{example_name}" do
          let(:service_numbers) { example_service_numbers }

          it "returns #{expected_result} with '#{example_service_numbers.join(', ')}'" do
            expect(result).to eq [
              [
                expected_result,
                example_service_numbers
              ]
            ]
          end
        end
      end
    end

    context 'when only security services are selected' do
      [
        [
          'officer services only',
          security_officer_service_numbers,
          '4b'
        ],
        [
          'officer and system services',
          security_officer_service_numbers + security_systems_service_numbers,
          '4a'
        ],
        [
          'officer and advisory services',
          security_officer_service_numbers + security_advisory_service_numbers,
          '4a'
        ],
        [
          'officer and mixed services',
          security_officer_service_numbers +
            security_officer_and_systems_service_numbers,
          '4b'
        ],
        [
          'officer, system and advisory services',
          security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers,
          '4a'
        ],
        [
          'officer, system and mixed services',
          security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers,
          '4a'
        ],
        [
          'officer, advisory and mixed services',
          security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
          '4a'
        ],
        [
          'officer, system, advisory and mixed services',
          security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
          '4a'
        ],
        [
          'systems services only',
          security_systems_service_numbers,
          '4c'
        ],
        [
          'systems and advisory services',
          security_systems_service_numbers + security_advisory_service_numbers,
          '4a'
        ],
        [
          'systems and mixed services',
          security_systems_service_numbers + security_officer_and_systems_service_numbers,
          '4c'
        ],
        [
          'systems, advisory and mixed services',
          security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
          '4a'
        ],
        [
          'advisory services only',
          security_advisory_service_numbers,
          '4d'
        ],
        [
          'advisory and mixed services',
          security_advisory_service_numbers + security_officer_and_systems_service_numbers,
          '4a'
        ],
        [
          'mixed services only',
          security_officer_and_systems_service_numbers,
          '4a'
        ],
      ].each do |example_name, example_service_numbers, expected_result|
        context "when there are #{example_name}" do
          let(:service_numbers) { example_service_numbers }

          it "returns #{expected_result} with '#{example_service_numbers.join(', ')}'" do
            expect(result).to eq [
              [
                expected_result,
                example_service_numbers
              ]
            ]
          end
        end
      end
    end

    context 'when there is a mix of FM and security services' do
      context 'when the FM services are hard' do
        [
          [
            'officer',
            security_officer_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + security_officer_service_numbers
              ]
            ]
          ],
          [
            'officer and system',
            security_officer_service_numbers + security_systems_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers
              ]
            ]
          ],
          [
            'officer and advisory',
            security_officer_service_numbers + security_advisory_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer and mixed',
            security_officer_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4b',
                security_officer_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system and advisory',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer, system and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, advisory and mixed',
            security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system, advisory and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems',
            security_systems_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers
              ]
            ]
          ],
          [
            'systems and advisory',
            security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'systems and mixed',
            security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems, advisory and mixed',
            security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'advisory',
            security_advisory_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4d',
                security_advisory_service_numbers
              ]
            ]
          ],
          [
            'advisory and mixed',
            security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4a',
                security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'mixed',
            security_officer_and_systems_service_numbers,
            [
              [
                '2a',
                hard_service_numbers
              ],
              [
                '4a',
                security_officer_and_systems_service_numbers
              ]
            ]
          ],
        ].each do |example_name, example_service_numbers, expected_results|
          context "and there are #{example_name} security services" do
            let(:service_numbers) { hard_service_numbers + example_service_numbers }

            it "returns #{expected_results.map { |expected_result| "#{expected_result[0]} with '#{expected_result[1].join(', ')}'" }.join(' and ')}" do
              expect(result).to eq expected_results
            end
          end
        end
      end

      context 'when the FM services are soft' do
        [
          [
            'officer',
            security_officer_service_numbers,
            [
              [
                '3a',
                soft_service_numbers + security_officer_service_numbers
              ]
            ]
          ],
          [
            'officer and system',
            security_officer_service_numbers + security_systems_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers
              ]
            ]
          ],
          [
            'officer and advisory',
            security_officer_service_numbers + security_advisory_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer and mixed',
            security_officer_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4b',
                security_officer_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system and advisory',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer, system and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, advisory and mixed',
            security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system, advisory and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems',
            security_systems_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers
              ]
            ]
          ],
          [
            'systems and advisory',
            security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'systems and mixed',
            security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems, advisory and mixed',
            security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'advisory',
            security_advisory_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4d',
                security_advisory_service_numbers
              ]
            ]
          ],
          [
            'advisory and mixed',
            security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4a',
                security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'mixed',
            security_officer_and_systems_service_numbers,
            [
              [
                '3a',
                soft_service_numbers
              ],
              [
                '4a',
                security_officer_and_systems_service_numbers
              ]
            ]
          ],
        ].each do |example_name, example_service_numbers, expected_results|
          context "and there are #{example_name} security services" do
            let(:service_numbers) { soft_service_numbers + example_service_numbers }

            it "returns #{expected_results.map { |expected_result| "#{expected_result[0]} with '#{expected_result[1].join(', ')}'" }.join(' and ')}" do
              expect(result).to eq expected_results
            end
          end
        end
      end

      context 'when the FM services are total' do
        [
          [
            'officer',
            security_officer_service_numbers,
            [
              [
                '1a',
                total_service_numbers + security_officer_service_numbers
              ]
            ]
          ],
          [
            'officer and system',
            security_officer_service_numbers + security_systems_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers
              ]
            ]
          ],
          [
            'officer and advisory',
            security_officer_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer and mixed',
            security_officer_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4b',
                security_officer_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system and advisory',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer, system and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, advisory and mixed',
            security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system, advisory and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems',
            security_systems_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers
              ]
            ]
          ],
          [
            'systems and advisory',
            security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'systems and mixed',
            security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems, advisory and mixed',
            security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'advisory',
            security_advisory_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4d',
                security_advisory_service_numbers
              ]
            ]
          ],
          [
            'advisory and mixed',
            security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4a',
                security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'mixed',
            security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                total_service_numbers
              ],
              [
                '4a',
                security_officer_and_systems_service_numbers
              ]
            ]
          ],
        ].each do |example_name, example_service_numbers, expected_results|
          context "and there are #{example_name} security services" do
            let(:service_numbers) { total_service_numbers + example_service_numbers }

            it "returns #{expected_results.map { |expected_result| "#{expected_result[0]} with '#{expected_result[1].join(', ')}'" }.join(' and ')}" do
              expect(result).to eq expected_results
            end
          end
        end
      end

      context 'when the FM services are mixed' do
        [
          [
            'officer',
            security_officer_service_numbers,
            [
              [
                '3a',
                hard_and_soft_service_numbers + security_officer_service_numbers
              ]
            ]
          ],
          [
            'officer and system',
            security_officer_service_numbers + security_systems_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers
              ]
            ]
          ],
          [
            'officer and advisory',
            security_officer_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer and mixed',
            security_officer_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4b',
                security_officer_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system and advisory',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer, system and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, advisory and mixed',
            security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system, advisory and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems',
            security_systems_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers
              ]
            ]
          ],
          [
            'systems and advisory',
            security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'systems and mixed',
            security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems, advisory and mixed',
            security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'advisory',
            security_advisory_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4d',
                security_advisory_service_numbers
              ]
            ]
          ],
          [
            'advisory and mixed',
            security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4a',
                security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'mixed',
            security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_and_soft_service_numbers
              ],
              [
                '4a',
                security_officer_and_systems_service_numbers
              ]
            ]
          ],
        ].each do |example_name, example_service_numbers, expected_results|
          context "and there are #{example_name} security services" do
            let(:service_numbers) { hard_and_soft_service_numbers + example_service_numbers }

            it "returns #{expected_results.map { |expected_result| "#{expected_result[0]} with '#{expected_result[1].join(', ')}'" }.join(' and ')}" do
              expect(result).to eq expected_results
            end
          end
        end
      end

      context 'when the FM services are hard and soft' do
        [
          [
            'officer',
            security_officer_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + security_officer_service_numbers
              ]
            ]
          ],
          [
            'officer and system',
            security_officer_service_numbers + security_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers
              ]
            ]
          ],
          [
            'officer and advisory',
            security_officer_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer and mixed',
            security_officer_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4b',
                security_officer_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system and advisory',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer, system and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, advisory and mixed',
            security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system, advisory and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems',
            security_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers
              ]
            ]
          ],
          [
            'systems and advisory',
            security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'systems and mixed',
            security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems, advisory and mixed',
            security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'advisory',
            security_advisory_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4d',
                security_advisory_service_numbers
              ]
            ]
          ],
          [
            'advisory and mixed',
            security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4a',
                security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'mixed',
            security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers
              ],
              [
                '4a',
                security_officer_and_systems_service_numbers
              ]
            ]
          ],
        ].each do |example_name, example_service_numbers, expected_results|
          context "and there are #{example_name} security services" do
            let(:service_numbers) { hard_service_numbers + soft_service_numbers + example_service_numbers }

            it "returns #{expected_results.map { |expected_result| "#{expected_result[0]} with '#{expected_result[1].join(', ')}'" }.join(' and ')}" do
              expect(result).to eq expected_results
            end
          end
        end
      end

      context 'when the FM services are hard and total' do
        [
          [
            'officer',
            security_officer_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers + security_officer_service_numbers
              ]
            ]
          ],
          [
            'officer and system',
            security_officer_service_numbers + security_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers
              ]
            ]
          ],
          [
            'officer and advisory',
            security_officer_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer and mixed',
            security_officer_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4b',
                security_officer_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system and advisory',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer, system and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, advisory and mixed',
            security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system, advisory and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems',
            security_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers
              ]
            ]
          ],
          [
            'systems and advisory',
            security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'systems and mixed',
            security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems, advisory and mixed',
            security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'advisory',
            security_advisory_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4d',
                security_advisory_service_numbers
              ]
            ]
          ],
          [
            'advisory and mixed',
            security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'mixed',
            security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_and_systems_service_numbers
              ]
            ]
          ],
        ].each do |example_name, example_service_numbers, expected_results|
          context "and there are #{example_name} security services" do
            let(:service_numbers) { hard_service_numbers + total_service_numbers + example_service_numbers }

            it "returns #{expected_results.map { |expected_result| "#{expected_result[0]} with '#{expected_result[1].join(', ')}'" }.join(' and ')}" do
              expect(result).to eq expected_results
            end
          end
        end
      end

      context 'when the FM services are soft and total' do
        [
          [
            'officer',
            security_officer_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers + security_officer_service_numbers
              ]
            ]
          ],
          [
            'officer and system',
            security_officer_service_numbers + security_systems_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers
              ]
            ]
          ],
          [
            'officer and advisory',
            security_officer_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer and mixed',
            security_officer_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4b',
                security_officer_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system and advisory',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer, system and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, advisory and mixed',
            security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system, advisory and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems',
            security_systems_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers
              ]
            ]
          ],
          [
            'systems and advisory',
            security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'systems and mixed',
            security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems, advisory and mixed',
            security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'advisory',
            security_advisory_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4d',
                security_advisory_service_numbers
              ]
            ]
          ],
          [
            'advisory and mixed',
            security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'mixed',
            security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_and_systems_service_numbers
              ]
            ]
          ],
        ].each do |example_name, example_service_numbers, expected_results|
          context "and there are #{example_name} security services" do
            let(:service_numbers) { soft_service_numbers + total_service_numbers + example_service_numbers }

            it "returns #{expected_results.map { |expected_result| "#{expected_result[0]} with '#{expected_result[1].join(', ')}'" }.join(' and ')}" do
              expect(result).to eq expected_results
            end
          end
        end
      end

      context 'when the FM services are hard, soft and total' do
        [
          [
            'officer',
            security_officer_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers + security_officer_service_numbers
              ]
            ]
          ],
          [
            'officer and system',
            security_officer_service_numbers + security_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers
              ]
            ]
          ],
          [
            'officer and advisory',
            security_officer_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer and mixed',
            security_officer_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4b',
                security_officer_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system and advisory',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'officer, system and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, advisory and mixed',
            security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'officer, system, advisory and mixed',
            security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_service_numbers + security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems',
            security_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers
              ]
            ]
          ],
          [
            'systems and advisory',
            security_systems_service_numbers + security_advisory_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers
              ]
            ]
          ],
          [
            'systems and mixed',
            security_systems_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4c',
                security_systems_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'systems, advisory and mixed',
            security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_systems_service_numbers + security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'advisory',
            security_advisory_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4d',
                security_advisory_service_numbers
              ]
            ]
          ],
          [
            'advisory and mixed',
            security_advisory_service_numbers + security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_advisory_service_numbers + security_officer_and_systems_service_numbers
              ]
            ]
          ],
          [
            'mixed',
            security_officer_and_systems_service_numbers,
            [
              [
                '1a',
                hard_service_numbers + soft_service_numbers + total_service_numbers
              ],
              [
                '4a',
                security_officer_and_systems_service_numbers
              ]
            ]
          ],
        ].each do |example_name, example_service_numbers, expected_results|
          context "and there are #{example_name} security services" do
            let(:service_numbers) { hard_service_numbers + soft_service_numbers + total_service_numbers + example_service_numbers }

            it "returns #{expected_results.map { |expected_result| "#{expected_result[0]} with '#{expected_result[1].join(', ')}'" }.join(' and ')}" do
              expect(result).to eq expected_results
            end
          end
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
