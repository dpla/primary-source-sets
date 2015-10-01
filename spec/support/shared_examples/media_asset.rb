shared_examples 'media asset' do

  let(:asset) { described_class.new(attributes) }

  it 'has many attachments' do
    expect(described_class.reflect_on_association(:attachments).macro)
      .to eq :has_many
  end

  it 'has many sources' do
    expect(described_class.reflect_on_association(:sources).macro)
      .to eq :has_many
  end

  it 'should recognize source' do
    source = create(:source_factory)
    asset = described_class.create(attributes)
    asset.sources << source
    expect(asset.sources).to eq [source]
  end

  it 'is invalid without file_base' do
    attributes[:file_base] = nil
    expect(described_class.new(attributes)).not_to be_valid
  end
end
