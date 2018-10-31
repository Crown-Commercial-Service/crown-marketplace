require 'rails_helper'

RSpec.describe StaticRecord, type: :model do
  subject(:klass) do
    Class.new do
      include StaticRecord
      attr_accessor :id, :name
    end
  end

  context 'when some records have been defined' do
    let(:a) { klass.new(id: '1', name: 'a') }
    let(:b) { klass.new(id: '2', name: 'b') }
    let(:c) { klass.new(id: '3', name: 'b') }

    before do
      klass.all << a
      klass.all << b
      klass.all << c
    end

    it 'returns all records' do
      expect(klass.all).to eq([a, b, c])
    end

    it 'finds records by one key' do
      expect(klass.find_by(id: '1')).to eq(a)
    end

    it 'finds records by two keys' do
      expect(klass.find_by(id: '2', name: 'b')).to eq(b)
    end

    it 'does not find non-matching records' do
      expect(klass.find_by(id: '3', name: 'c')).to be_nil
    end
  end

  context 'when defining records en masse' do
    before do
      klass.define(%i[id name], [['1', 'one'], ['2', 'two']])
    end

    it 'stores all defined records' do
      expect(klass.all).to match(
        [
          an_object_having_attributes(id: '1', name: 'one'),
          an_object_having_attributes(id: '2', name: 'two')
        ]
      )
    end

    it 'freezes individual records' do
      expect { klass.all.first.name = 'NEW' }
        .to raise_exception(FrozenError)
    end

    it 'freezes the collection' do
      expect { klass.all << klass.new(id: '3', name: 'three') }
        .to raise_exception(FrozenError)
    end
  end
end
