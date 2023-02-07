require 'rails_helper'

RSpec.describe WorkingDays do
  stub_bank_holiday_json

  describe '#bank_holiday?' do
    context 'when it is not a bank holiday' do
      it 'will return false' do
        expect(described_class.bank_holiday?(DateTime.new(2020, 3, 15, 12, 12, 12).in_time_zone('London').to_date)).to be false
        expect(described_class.bank_holiday?(DateTime.new(2020, 2, 19, 14, 5, 1).in_time_zone('London').to_date)).to be false
        expect(described_class.bank_holiday?(DateTime.new(2020, 9, 30, 1, 4, 57).in_time_zone('London').to_date)).to be false
      end
    end

    context 'when it is a bank holiday' do
      it 'will return true' do
        expect(described_class.bank_holiday?(DateTime.new(2021, 12, 27, 20, 34, 8).in_time_zone('London').to_date)).to be true
        expect(described_class.bank_holiday?(DateTime.new(2020, 3, 17, 21, 4, 5).in_time_zone('London').to_date)).to be true
        expect(described_class.bank_holiday?(DateTime.new(2020, 8, 3, 13, 28, 19).in_time_zone('London').to_date)).to be true
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe '#working_days' do
    context 'when given two working days' do
      # NO BANK HOLIDAYS
      context 'when it is a normal week without bank holidays' do
        context 'when the start date is a Monday' do
          it 'is expeted to return the Wednesday' do
            expect(described_class.working_days(2, DateTime.new(2020, 3, 2, 23, 59, 59).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 3, 4, 23, 59, 59).in_time_zone('London')
          end
        end

        context 'when the start date is a Tuesday' do
          it 'is expeted to return the Thursday' do
            expect(described_class.working_days(2, DateTime.new(2020, 3, 3, 13, 14, 1).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 3, 5, 13, 14, 1).in_time_zone('London')
          end
        end

        context 'when the start date is a Wednesday' do
          it 'is expeted to return the Friday' do
            expect(described_class.working_days(2, DateTime.new(2020, 3, 4, 1, 45, 57).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 3, 6, 1, 45, 57).in_time_zone('London')
          end
        end

        context 'when the start date is a Thrusday' do
          it 'is expeted to return the Monday' do
            expect(described_class.working_days(2, DateTime.new(2020, 3, 5, 13, 5, 8).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 3, 9, 13, 5, 8).in_time_zone('London')
          end
        end

        context 'when the start date is a Friday' do
          it 'is expeted to return the Tuesday' do
            expect(described_class.working_days(2, DateTime.new(2020, 3, 6, 21, 45, 12).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 3, 10, 21, 45, 12).in_time_zone('London')
          end
        end

        context 'when the start date is a Saturday' do
          it 'is expeted to return the Wednesday' do
            expect(described_class.working_days(2, DateTime.new(2020, 3, 7, 10, 4, 7).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 3, 11, 0, 0, 0).in_time_zone('London')
          end
        end

        context 'when the start date is a Sunday' do
          it 'is expeted to return the Wednesday' do
            expect(described_class.working_days(2, DateTime.new(2020, 3, 8, 1, 2, 22).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 3, 11, 0, 0, 0).in_time_zone('London')
          end
        end
      end

      # BANK HOLIDAYS
      context 'when it is a week with bank holidays' do
        context 'when the start date is a Monday with a bank holiday on Tuesday' do
          it 'is expeted to return the next Thursday' do
            expect(described_class.working_days(2, DateTime.new(2020, 3, 16, 22, 34, 54).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 3, 19, 22, 34, 54).in_time_zone('London')
          end
        end

        context 'when the start date is a Tuesday with a bank holiday on Wednesday and Thursday' do
          it 'is expeted to return the next Monday' do
            expect(described_class.working_days(2, DateTime.new(2019, 12, 24, 21, 12, 8).in_time_zone('London').to_datetime)).to eq DateTime.new(2019, 12, 30, 21, 12, 8).in_time_zone('London')
          end
        end

        context 'when the start date is a Wednesday with a bank holiday on Friday' do
          it 'is expeted to return the next Monday' do
            expect(described_class.working_days(2, DateTime.new(2020, 5, 6, 20, 19, 18).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 5, 11, 20, 19, 18).in_time_zone('London')
          end
        end

        context 'when the start date is a Thrusday with a bank holiday on Monday' do
          it 'is expeted to return the next Tuesday' do
            expect(described_class.working_days(2, DateTime.new(2020, 5, 21, 19, 32, 7).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 5, 26, 19, 32, 7).in_time_zone('London')
          end
        end

        context 'when the start date is a Friday with a bank holiday on Monday' do
          it 'is expeted to return the next Wednesday' do
            expect(described_class.working_days(2, DateTime.new(2019, 5, 3, 18, 54, 31).in_time_zone('London').to_datetime)).to eq DateTime.new(2019, 5, 8, 18, 54, 31).in_time_zone('London')
          end
        end

        context 'when the start date is a Saturday with a bank holiday on Monday' do
          it 'is expeted to return the next Thursday' do
            expect(described_class.working_days(2, DateTime.new(2020, 7, 11, 17, 3, 7).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 7, 15, 23, 0, 0, '+1').in_time_zone('London')
          end
        end

        context 'when the start date is a Sunday with a bank holiday on Monday' do
          it 'is expeted to return the next Thursday' do
            expect(described_class.working_days(2, DateTime.new(2021, 4, 4, 18, 4, 32).in_time_zone('London').to_datetime)).to eq DateTime.new(2021, 4, 7, 23, 0, 0, '+1').in_time_zone('London')
          end
        end

        context 'when the start date is a a bank holiday' do
          it 'is expected to return in two working days' do
            expect(described_class.working_days(2, DateTime.new(2020, 3, 17, 16, 1, 23).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 3, 20, 0, 0, 0).in_time_zone('London')
            expect(described_class.working_days(2, DateTime.new(2020, 12, 25, 15, 46, 12).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 12, 31, 0, 0, 0).in_time_zone('London')
            expect(described_class.working_days(2, DateTime.new(2021, 4, 5, 11, 3, 27).in_time_zone('London').to_datetime)).to eq DateTime.new(2021, 4, 7, 23, 0, 0, '+1').in_time_zone('London')
          end
        end
      end
    end

    context 'when given one working day' do
      context 'when it is a normal week without bank holidays' do
        it 'is expected to return in one working day' do
          expect(described_class.working_days(1, DateTime.new(2020, 9, 7, 11, 12, 12).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 9, 8, 12, 12, 12, '+1').in_time_zone('London')
          expect(described_class.working_days(1, DateTime.new(2020, 9, 9, 13, 41, 11).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 9, 10, 14, 41, 11, '+1').in_time_zone('London')
          expect(described_class.working_days(1, DateTime.new(2020, 9, 12, 18, 56, 32).in_time_zone('London').to_datetime)).to eq DateTime.new(2020, 9, 14, 23, 0, 0, '+1').in_time_zone('London')
        end
      end

      context 'when it is a week with bank holidays' do
        it 'is expected to return in one working day' do
          expect(described_class.working_days(1, DateTime.new(2021, 3, 31, 17, 12, 1).in_time_zone('London').to_datetime)).to eq DateTime.new(2021, 4, 1, 18, 12, 1, '+1').in_time_zone('London')
          expect(described_class.working_days(1, DateTime.new(2021, 4, 1, 14, 3, 21).in_time_zone('London').to_datetime)).to eq DateTime.new(2021, 4, 6, 15, 3, 21, '+1').in_time_zone('London')
          expect(described_class.working_days(1, DateTime.new(2021, 4, 3, 15, 6, 38).in_time_zone('London').to_datetime)).to eq DateTime.new(2021, 4, 6, 23, 0, 0, '+1').in_time_zone('London')
        end

        context 'when the start date is a bank holiday' do
          it 'is expected to return in one working day' do
            expect(described_class.working_days(1, DateTime.new(2021, 4, 2, 21, 4, 52).in_time_zone('London').to_datetime)).to eq DateTime.new(2021, 4, 6, 23, 0, 0, '+1').in_time_zone('London')
            expect(described_class.working_days(1, DateTime.new(2021, 8, 2, 6, 54, 2).in_time_zone('London').to_datetime)).to eq DateTime.new(2021, 8, 3, 23, 0, 0, '+1').in_time_zone('London')
            expect(described_class.working_days(1, DateTime.new(2021, 8, 29, 23, 4, 3).in_time_zone('London').to_datetime)).to eq DateTime.new(2021, 8, 31, 23, 0, 0, '+1').in_time_zone('London')
          end
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
