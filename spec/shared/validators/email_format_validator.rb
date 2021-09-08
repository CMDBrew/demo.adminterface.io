shared_examples 'validators/email_format' do |attr|
  let(:record) { build_stubbed(described_class.model_name.param_key) }

  it 'returns invalid for email format— ####' do
    record.send("#{attr}=", 'abcd')
    expect(record).not_to be_valid
  end

  it 'returns invalid for email format— ####@##' do
    record.send("#{attr}=", 'abcd@as')
    expect(record).not_to be_valid
  end

  it 'returns invalid for email format— ####.##' do
    record.send("#{attr}=", 'abcd.com')
    expect(record).not_to be_valid
  end
end
