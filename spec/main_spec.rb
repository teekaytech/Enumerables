require './main'

describe Enumerable do
  let(:array) { [1, 2, 3, 4, 5] }
  let(:mixed_values) { [1, 2, 3, 4, a] }
  let(:string_values) { %w[ant bear cat] }
  let(:float_values) { [1, 3.14, 42] }
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
      expect(result).to eq(["color : #fff", "font_family : Arial"])
    end

    it 'returns the enumerator data if block is not given' do
      expect(array.my_each_with_index).to be_an(Enumerator)
    end
  end

  describe '#my_select' do
    context 'if block is given returns true' do
      it 'returns an array containing all elements of array' do
        result = []
        array.my_select { |item| result << item if item.even? }
        expect(result).to eq([2, 4])
      end

      it 'returns a hash containing all elements/keys of hash' do
        result = hash.my_select { |val| val > 'a' }
        expect(result).to eq({ 'color' => '#fff', 'font_family' => 'Arial' })
      end
    end
    it 'returns the enumerator data if block is not given' do
      expect(array.my_select).to be_an(Enumerator)
    end
  end
end
