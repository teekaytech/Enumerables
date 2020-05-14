require './main'

describe Enumerable do
  let(:array) { [1, 2, 3, 4, 5] }
  let(:mixed_val) { [1, 2, 3, 4, a] }
  let(:string_val) { %w[ant bear cat] }
  let(:float_val) { [1, 3.14, 42] }
  let(:empty_array) { [] }
  let(:nil_array) { [nil] }
  let(:nil_false_array) { [nil, false] }
  let(:nil_false_true) { [nil, false, true] }
  let(:hash) { { 'color' => '#fff', 'font_family' => 'Arial' } }

  describe '#my_each' do
    it 'returns each items of array/range if block is given' do
      result = []
      array.my_each { |item| result << item + 1 }
      expect(result).to eq([2, 3, 4, 5, 6])
    end

    it 'returns keys and values of hash if block is given' do
      result = []
      hash.my_each { |key, value| result << key + ' : ' + value }
      expect(result).to eq(["color : #fff", "font_family : Arial"])
    end

    it 'returns the enumerator data if block is not given' do
      expect(array.my_each).to be_an(Enumerator)
    end
  end

  describe '#my_each_with_index' do
    it 'returns values and keys of array/range if block is given' do
      result = []
      array.my_each_with_index { |item, index| result << item + index }
      expect(result).to eq([1, 3, 5, 7, 9])
    end

    it 'returns values and keys of hash if block is given' do
      result = []
      hash.my_each_with_index { |value, key| result << value + ' : ' + key }
      expect(result).to eq(['color : #fff', 'font_family : Arial'])
    end

    it 'returns the enumerator data if block is not given' do
      expect(array.my_each_with_index).to be_an(Enumerator)
    end
  end

  describe '#my_select' do
    context 'if block is given returns true' do
      it 'returns an array containing all elements of array/range' do
        result = []
        array.my_select { |item| result << item if item.even? }
        expect(result).to eq([2, 4])
      end

      it 'returns a hash containing all elements/keys of hash' do
        result = hash.my_select { |val| val > 'a' }
        expect(result).to eq({ 'color' => '#fff', 'font_family' => 'Arial' })
      end
    end

    it 'returns empty array if block is given but returns false' do
      result = []
      array.my_select { |item| result << item if item > 10 }
      expect(result).to eq([])
    end

    it 'returns the enumerator data if block is not given' do
      expect(array.my_select).to be_an(Enumerator)
    end
  end

  describe '#my_all?' do
    context 'if block is given' do
      it 'returns true if block never returns false or nil' do
        result = string_val.my_all? { |item| item.length >= 3 }
        expect(result).to eq(true)
      end

      it 'returns false if block returns false or nil' do
        result = string_val.my_all? { |item| item.length >= 5 }
        expect(result).to eq(false)
      end
    end

    it 'returns true if block is not given and none of the items return false or nill' do
      expect(string_val.my_all?).to eq(true)
    end

    context 'if block is not given a parameter is given' do
      it 'return true if all the items return true for the parameter given' do
        expect(string_val.my_all?(String)).to eq(true)
      end
    end
  end
end
