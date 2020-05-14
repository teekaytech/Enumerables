require './main'

describe Enumerable do
  let(:numeric_values) { [1, 2, 3, 4, 5] }
  let(:mixed_values) { [1, 2, 3, 4, a] }
  let(:string_values) { %w[ant bear cat] }
  let(:float_values) { [1, 3.14, 42] }
  let(:empty_array) { [] }
  let(:nil_array) { [nil] }
  let(:nil_false_array) { [nil, false] }
  let(:nil_false_true) { [nil, false, true] }

  describe '#my_each' do
    it 'returns each array items if block is given' do
      result = []
      numeric_values.my_each { |item| result << item + 1 }
      expect(result).to eq([2, 3, 4, 5, 6])
    end
  end
end
