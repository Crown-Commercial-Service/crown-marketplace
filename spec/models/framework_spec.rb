require 'rails_helper'

# rubocop:disable RSpec/NestedGroups
RSpec.describe Framework do
  describe '.frameworks' do
    context 'when no scope is provided' do
      it 'returns RM3830 and RM6232' do
        expect(described_class.frameworks).to eq %w[RM3830 RM6232]
      end
    end

    context 'when the facilities_management scope is provided' do
      it 'returns RM3830 and RM6232' do
        expect(described_class.facilities_management.frameworks).to eq %w[RM3830 RM6232]
      end
    end
  end

  describe '.live_frameworks' do
    context 'when RM6232 goes live tomorrow' do
      include_context 'and RM6232 is live in the future'

      context 'and RM3830 framework is still live' do
        include_context 'and RM3830 is live'

        it 'returns RM3830' do
          expect(described_class.live_frameworks).to match_array %w[RM3830]
        end

        context 'and the facilities_management scope is provided' do
          it 'returns RM3830' do
            expect(described_class.facilities_management.live_frameworks).to eq %w[RM3830]
          end
        end
      end

      context 'and RM3830 framework has expired' do
        it 'returns an empty array' do
          expect(described_class.live_frameworks).to be_empty
        end

        context 'and the facilities_management scope is provided' do
          it 'returns an empty array' do
            expect(described_class.facilities_management.live_frameworks).to be_empty
          end
        end
      end
    end

    context 'when RM6232 is live today' do
      include_context 'and RM6232 is live today'

      context 'and RM3830 framework is still live' do
        include_context 'and RM3830 is live'

        it 'returns RM3830 and RM6232' do
          expect(described_class.live_frameworks).to match_array %w[RM3830 RM6232]
        end

        context 'and the facilities_management scope is provided' do
          it 'returns RM3830 and RM6232' do
            expect(described_class.facilities_management.live_frameworks).to eq %w[RM3830 RM6232]
          end
        end
      end

      context 'and RM3830 framework has expired' do
        it 'returns RM6232' do
          expect(described_class.live_frameworks).to eq %w[RM6232]
        end

        context 'and the facilities_management scope is provided' do
          it 'returns RM6232' do
            expect(described_class.facilities_management.live_frameworks).to eq %w[RM6232]
          end
        end
      end
    end

    context 'when RM6232 went live yesterday' do
      context 'and RM3830 framework is still live' do
        include_context 'and RM3830 is live'

        it 'returns RM3830 and RM6232' do
          expect(described_class.live_frameworks).to match_array %w[RM3830 RM6232]
        end

        context 'and the supply_teachers scope is provided' do
          it 'returns RM3830 and RM6232' do
            expect(described_class.facilities_management.live_frameworks).to eq %w[RM3830 RM6232]
          end
        end
      end

      context 'and RM3830 framework has expired' do
        it 'returns RM6232' do
          expect(described_class.live_frameworks).to eq %w[RM6232]
        end

        context 'and the supply_teachers scope is provided' do
          it 'returns RM6232' do
            expect(described_class.facilities_management.live_frameworks).to eq %w[RM6232]
          end
        end
      end
    end
  end

  describe '.current_framework' do
    context 'when the facilities_management scope is provided' do
      context 'when RM6232 goes live tomorrow' do
        include_context 'and RM6232 is live in the future'

        context 'and RM3830 framework is still live' do
          include_context 'and RM3830 is live'

          it 'returns RM3830' do
            expect(described_class.facilities_management.current_framework).to eq 'RM3830'
          end
        end

        context 'and RM3830 framework has expired' do
          it 'returns nil' do
            expect(described_class.facilities_management.current_framework).to be_nil
          end
        end
      end

      context 'when RM6232 is live today' do
        include_context 'and RM6232 is live today'

        context 'and RM3830 framework is still live' do
          include_context 'and RM3830 is live'

          it 'returns RM6232' do
            expect(described_class.facilities_management.current_framework).to eq 'RM6232'
          end
        end

        context 'and RM3830 framework has expired' do
          it 'returns RM6232' do
            expect(described_class.facilities_management.current_framework).to eq 'RM6232'
          end
        end
      end

      context 'when RM6232 went live yesterday' do
        context 'and RM3830 framework is still live' do
          include_context 'and RM3830 is live'

          it 'returns RM6232' do
            expect(described_class.facilities_management.current_framework).to eq 'RM6232'
          end
        end

        context 'and RM3830 framework has expired' do
          it 'returns RM6232' do
            expect(described_class.facilities_management.current_framework).to eq 'RM6232'
          end
        end
      end
    end
  end

  describe '.live_framework?' do
    context 'when the facilities_management scope is provided' do
      let(:result) { described_class.facilities_management.live_framework?(framework) }

      context 'when the framework passed is RM3830' do
        let(:framework) { 'RM3830' }

        context 'and RM6232 goes live tomorrow' do
          include_context 'and RM6232 is live in the future'

          context 'and RM3830 framework is still live' do
            include_context 'and RM3830 is live'

            it 'returns true' do
              expect(result).to be true
            end
          end

          context 'and RM3830 framework has expired' do
            it 'returns false' do
              expect(result).to be false
            end
          end
        end

        context 'when RM6232 is live today' do
          include_context 'and RM6232 is live today'

          context 'and RM3830 framework is still live' do
            include_context 'and RM3830 is live'

            it 'returns true' do
              expect(result).to be true
            end
          end

          context 'and RM3830 framework has expired' do
            it 'returns false' do
              expect(result).to be false
            end
          end
        end

        context 'and RM6232 went live yesterday' do
          context 'and RM3830 framework is still live' do
            include_context 'and RM3830 is live'

            it 'returns true' do
              expect(result).to be true
            end
          end

          context 'and RM3830 framework has expired' do
            it 'returns false' do
              expect(result).to be false
            end
          end
        end
      end

      context 'when the framework passed is RM6232' do
        let(:framework) { 'RM6232' }

        context 'and RM6232 goes live tomorrow' do
          include_context 'and RM6232 is live in the future'

          context 'and RM3830 framework is still live' do
            include_context 'and RM3830 is live'

            it 'returns false' do
              expect(result).to be false
            end
          end

          context 'and RM3830 framework has expired' do
            it 'returns false' do
              expect(result).to be false
            end
          end
        end

        context 'when RM6232 is live today' do
          include_context 'and RM6232 is live today'

          context 'and RM3830 framework is still live' do
            include_context 'and RM3830 is live'

            it 'returns true' do
              expect(result).to be true
            end
          end

          context 'and RM3830 framework has expired' do
            it 'returns true' do
              expect(result).to be true
            end
          end
        end

        context 'and RM6232 went live yesterday' do
          context 'and RM3830 framework is still live' do
            include_context 'and RM3830 is live'

            it 'returns true' do
              expect(result).to be true
            end
          end

          context 'and RM3830 framework has expired' do
            it 'returns true' do
              expect(result).to be true
            end
          end
        end
      end

      context 'when the framework is neither RM3830 or RM6232' do
        let(:framework) { 'RM6187' }

        it 'returns false' do
          expect(result).to be false
        end
      end
    end
  end

  describe '.status' do
    let(:result) { described_class.find_by(framework:).status }

    context 'when considering facilities_management frameworks' do
      context 'when the framework passed is RM3830' do
        context 'and RM6232 goes live tomorrow' do
          include_context 'and RM6232 is live in the future'

          context 'and the frameworks is RM3830' do
            let(:framework) { 'RM3830' }

            context 'and RM3830 framework is still live' do
              include_context 'and RM3830 is live'

              it 'returns live' do
                expect(result).to eq :live
              end
            end

            context 'and RM3830 framework has expired' do
              it 'returns expired' do
                expect(result).to eq :expired
              end
            end
          end

          context 'and the frameworks is RM6232' do
            let(:framework) { 'RM6232' }

            context 'and RM3830 framework is still live' do
              include_context 'and RM3830 is live'

              it 'returns coming' do
                expect(result).to eq :coming
              end
            end

            context 'and RM3830 framework has expired' do
              it 'returns expired' do
                expect(result).to eq :coming
              end
            end
          end
        end

        context 'when RM6232 is live today' do
          include_context 'and RM6232 is live today'

          context 'and the frameworks is RM3830' do
            let(:framework) { 'RM3830' }

            context 'and RM3830 framework is still live' do
              include_context 'and RM3830 is live'

              it 'returns live' do
                expect(result).to eq :live
              end
            end

            context 'and RM3830 framework has expired' do
              it 'returns expired' do
                expect(result).to eq :expired
              end
            end
          end

          context 'and the frameworks is RM6232' do
            let(:framework) { 'RM6232' }

            context 'and RM3830 framework is still live' do
              include_context 'and RM3830 is live'

              it 'returns live' do
                expect(result).to eq :live
              end
            end

            context 'and RM3830 framework has expired' do
              it 'returns live' do
                expect(result).to eq :live
              end
            end
          end
        end

        context 'and RM6232 went live yesterday' do
          context 'and the frameworks is RM3830' do
            let(:framework) { 'RM3830' }

            context 'and RM3830 framework is still live' do
              include_context 'and RM3830 is live'

              it 'returns live' do
                expect(result).to eq :live
              end
            end

            context 'and RM3830 framework has expired' do
              it 'returns expired' do
                expect(result).to eq :expired
              end
            end
          end

          context 'and the frameworks is RM6232' do
            let(:framework) { 'RM6232' }

            context 'and RM3830 framework is still live' do
              include_context 'and RM3830 is live'

              it 'returns live' do
                expect(result).to eq :live
              end
            end

            context 'and RM3830 framework has expired' do
              it 'returns live' do
                expect(result).to eq :live
              end
            end
          end
        end
      end
    end
  end

  describe 'validating the live at date' do
    let(:framework) { create(:framework) }
    let(:live_at) { 1.day.from_now }
    let(:live_at_yyyy) { live_at.year.to_s }
    let(:live_at_mm) { live_at.month.to_s }
    let(:live_at_dd) { live_at.day.to_s }

    before do
      framework.live_at_yyyy = live_at_yyyy
      framework.live_at_mm = live_at_mm
      framework.live_at_dd = live_at_dd
    end

    context 'when considering live_at_yyyy and it is nil' do
      let(:live_at_yyyy) { nil }

      it 'is not valid and has the correct error message' do
        expect(framework.valid?(:update)).to be false
        expect(framework.errors[:live_at].first).to eq 'Enter a valid \'live at\' date'
      end
    end

    context 'when considering live_at_mm and it is blank' do
      let(:live_at_mm) { '' }

      it 'is not valid and has the correct error message' do
        expect(framework.valid?(:update)).to be false
        expect(framework.errors[:live_at].first).to eq 'Enter a valid \'live at\' date'
      end
    end

    context 'when considering live_at_dd and it is empty' do
      let(:live_at_dd) { '    ' }

      it 'is not valid and has the correct error message' do
        expect(framework.valid?(:update)).to be false
        expect(framework.errors[:live_at].first).to eq 'Enter a valid \'live at\' date'
      end
    end

    context 'when considering the full live_at' do
      context 'and it is not a real date' do
        let(:live_at_yyyy) { live_at.year.to_s }
        let(:live_at_mm) { '2' }
        let(:live_at_dd) { '30' }

        it 'is not valid and has the correct error message' do
          expect(framework.valid?(:update)).to be false
          expect(framework.errors[:live_at].first).to eq 'Enter a valid \'live at\' date'
        end
      end

      context 'and it is a real date' do
        it 'is valid' do
          expect(framework.valid?(:update)).to be true
        end
      end
    end
  end

  describe 'validating the expires at date' do
    let(:framework) { create(:framework) }
    let(:expires_at) { 2.years.from_now }
    let(:expires_at_yyyy) { expires_at.year.to_s }
    let(:expires_at_mm) { expires_at.month.to_s }
    let(:expires_at_dd) { expires_at.day.to_s }

    before do
      framework.expires_at_yyyy = expires_at_yyyy
      framework.expires_at_mm = expires_at_mm
      framework.expires_at_dd = expires_at_dd
    end

    context 'when considering expires_at_yyyy and it is nil' do
      let(:expires_at_yyyy) { nil }

      it 'is not valid and has the correct error message' do
        expect(framework.valid?(:update)).to be false
        expect(framework.errors[:expires_at].first).to eq 'Enter a valid \'expires at\' date'
      end
    end

    context 'when considering expires_at_mm and it is blank' do
      let(:expires_at_mm) { '' }

      it 'is not valid and has the correct error message' do
        expect(framework.valid?(:update)).to be false
        expect(framework.errors[:expires_at].first).to eq 'Enter a valid \'expires at\' date'
      end
    end

    context 'when considering expires_at_dd and it is empty' do
      let(:expires_at_dd) { '    ' }

      it 'is not valid and has the correct error message' do
        expect(framework.valid?(:update)).to be false
        expect(framework.errors[:expires_at].first).to eq 'Enter a valid \'expires at\' date'
      end
    end

    context 'when considering the full expires_at' do
      context 'and it is not a real date' do
        let(:expires_at_yyyy) { expires_at.year.to_s }
        let(:expires_at_mm) { '2' }
        let(:expires_at_dd) { '30' }

        it 'is not valid and has the correct error message' do
          expect(framework.valid?(:update)).to be false
          expect(framework.errors[:expires_at].first).to eq 'Enter a valid \'expires at\' date'
        end
      end

      context 'and it is a real date' do
        it 'is valid' do
          expect(framework.valid?(:update)).to be true
        end
      end
    end
  end

  describe 'validating the expires at date is after the live at date' do
    let(:framework) { create(:framework, live_at: today, expires_at: expires_at) }
    let(:today) { Time.zone.today }

    context 'when the expires at date is in the future' do
      let(:expires_at) { today + 1.year }

      it 'is valid' do
        expect(framework.valid?(:update)).to be true
      end
    end

    context 'when the expires at date is the same as the live at date' do
      let(:expires_at) { today }

      it 'is not valid and has the correct error message' do
        expect(framework.valid?(:update)).to be false
        expect(framework.errors[:expires_at].first).to eq "The 'expires at' date must be after the 'live at' date"
      end
    end

    context 'when the expires at date is before the live at date' do
      let(:expires_at) { today - 2.days }

      it 'is not valid and has the correct error message' do
        expect(framework.valid?(:update)).to be false
        expect(framework.errors[:expires_at].first).to eq "The 'expires at' date must be after the 'live at' date"
      end
    end
  end
end
# rubocop:enable RSpec/NestedGroups
