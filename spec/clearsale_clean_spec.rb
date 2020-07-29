# frozen_string_literal: true

RSpec.describe ClearsaleClean do
  it 'has a version number' do
    expect(described_class::VERSION).not_to be nil
  end

  it 'has a version number 0.1.0' do
    expect(described_class::VERSION).to eql '0.1.0'
  end
end
