require 'spec_helper'

RSpec.describe Regionite::Region do
  subject { Regionite::Region }

  describe '.[]' do
    it 'returns truthy for valid lowercase names' do
      expect(subject['north america'].slug).to eq(region.slug)
    end

    it 'returns truthy for valid uppercase names' do
      expect(subject['NORTH AMERICA'].slug).to eq(region.slug)
    end

    it 'returns truthy for valid titlecase names' do
      expect(subject['North America'].slug).to eq(region.slug)
    end

    it 'returns truthy for valid underscored names' do
      expect(subject['north_america'].slug).to eq(region.slug)
    end

    it 'returns truthy for valid slugs' do
      expect(subject[:north_america].slug).to eq(region.slug)
    end

    it 'returns truthy for region objects' do
      region = instance_double(Regionite::Region, slug: :north_america)
      expect(subject[region].slug).to eq(region.slug)
    end

    it 'returns nil for invalid region name' do
      expect(subject['n. america']).to be_nil
    end

    it 'raises an error for objects that are not regions/strings/symbols' do
      country = instance_double(Regionite::Country)

      expect { subject[country] }.to raise_error(ArgumentError,
        '"Regionite::Region[]" requires a string, symbol, or region.')
    end

    it 'raises an error for nil' do
      expect{ subject.is_region?(nil) }.to raise_error(ArgumentError,
        '"Regionite::Region[]" requires a string, symbol, or region.')
    end
  end

  describe '.exists?' do
    it 'returns truthy for valid lowercase names' do
      expect(subject.is_region?('north america')).to be_truthy
    end

    it 'returns truthy for valid uppercase names' do
      expect(subject.is_region?('NORTH AMERICA')).to be_truthy
    end

    it 'returns truthy for valid titlecase names' do
      expect(subject.is_region?('North America')).to be_truthy
    end

    it 'returns truthy for valid underscored names' do
      expect(subject.is_region?('north_america')).to be_truthy
    end

    it 'returns truthy for valid slugs' do
      expect(subject.is_region?(:north_america)).to be_truthy
    end

    it 'returns truthy for region objects' do
      region = instance_double(Regionite::Region, slug: :north_america)
      expect(subject.is_region?(region)).to be_truthy
    end

    it 'returns falsey for invalid region name' do
      expect(subject.is_region?('n. america')).to be_falsey
    end

    it 'returns falsey for country objects' do
      country = instance_double(Regionite::Country)
      expect(subject.is_region?(country)).to be_falsey
    end

    it 'raises an error for nil' do
      expect{ subject.is_region?(nil) }.to raise_error(ArgumentError,
        '"Regionite::Region.is_region?" requires a non-nil value.')
    end
  end

  describe '.search' do
    it 'returns an array' do
      expect(subject.search('north america')).to be_an(Array)
    end

    it 'returns an array of regions' do
      expect(subject.search('north america').first).to be_a(Regionite::Region)
    end

    it 'finds regions from lowercase names' do
      first_result = subject.search('north america').first

      expect(first_result.slug).to eq(:north_america)
    end

    it 'finds regions from uppercase names' do
      first_result = subject.search('NORTH AMERICA').first

      expect(first_result.slug).to eq(:north_america)
    end

    it 'finds regions from titlecase names' do
      first_result = subject.search('North America').first

      expect(first_result.slug).to eq(:north_america)
    end

    it 'finds regions from underscored names' do
      first_result = subject.search('north_america').first

      expect(first_result.slug).to eq(:north_america)
    end

    it 'finds regions from symbols' do
      first_result = subject.search(:north_america).first

      expect(first_result.slug).to eq(:north_america)
    end

    it 'finds regions with spaces removed' do
      first_result = subject.search('northamerica').first

      expect(first_result.slug).to eq(:north_america)
    end

    it 'finds regions from abbreviations' do
      first_result = subject.search('n. america').first

      expect(first_result.slug).to eq(:north_america)
    end

    it 'finds regions from abbreviations without punctuation' do
      first_result = subject.search('n. america').first

      expect(first_result.slug).to eq(:north_america)
    end

    it 'finds regions with abbreviations and spaces removed' do
      first_result = subject.search('namerica').first

      expect(first_result.slug).to eq(:north_america)
    end

    it 'raises an error for objects that are not regions/strings/symbols' do
      country = instance_double(Regionite::Country)

      expect { subject.search(country) }.to raise_error(ArgumentError,
        '"Regionite::Region.search" requires a string, symbol, or region.')
    end

    it 'raises an error for nil' do
      expect{ subject.search(nil) }.to raise_error(ArgumentError,
        '"Regionite::Region.search" requires a non-nil value.')
    end
  end

  describe '.region_names' do
    subject { super().region_names }

    it 'returns an array' do
      expect(subject).to be_an(Array)
    end

    it 'returns an array of strings' do
      expect(subject.first).to be_a(String)
    end
  end

  describe '.region_slugs' do
    subject { super().region_slugs }

    it 'returns an array' do
      expect(subject).to be_an(Array)
    end

    it 'returns an array of symbols' do
      expect(subject.first).to be_a(Symbol)
    end
  end

  describe '.region_names_and_slugs' do
    subject { super().regions }

    it 'returns a hash' do
      expect(subject).to be_a(Hash)
    end

    it 'returns a hash of (String, Symbol) entries' do
      entry = subject.first
      expect(entry[0]).to be_a(String)
      expect(entry[1]).to be_a(Symbol)
    end
  end

  describe '.regions' do
    subject { super().regions }

    it 'returns an array' do
      expect(subject).to be_an(Array)
    end

    it 'returns an array of region objects' do
      expect(subject.first).to be_a(Regionite::Region)
    end
  end

  describe '#codes' do
    let(:country_codes) { ['us', 'ca', 'mx'] }
    subject { super().new(name: 'North America',
      country_codes: country_codes).codes }

    it 'returns an array' do
      expect(subject).to be_an(Array)
    end

    it 'returns an array of strings' do
      expect(subject.first).to be_a(String)
    end

    it 'returns an array of 2-character codes' do
      expect(subject.first.to_s.length).to be(2)
    end

    it 'returns an array of downcased codes' do
      expect(subject.first.to_s).to be('us')
    end

    it 'returns the country codes in the region' do
      expect(subject).to match_array(country_codes)
    end
  end

  describe '#contains?' do
    subject { super().new(name: 'North America', country_codes: ['us']) }

    it 'returns truthy for included lowercase names' do
      expect(subject.contains?('united states')).to be_truthy
    end

    it 'returns truthy for included uppercase names' do
      expect(subject.contains?('UNITED STATES')).to be_truthy
    end

    it 'returns truthy for included titlecase names' do
      expect(subject.contains?('United States')).to be_truthy
    end

    it 'returns truthy for included underscored names' do
      expect(subject.contains?('united_states')).to be_truthy
    end

    it 'returns truthy for included slugs' do
      expect(subject.contains?(:us)).to be_truthy
    end

    it 'returns truthy for included objects' do
      region = instance_double(Regionite::Country, slug: :us)

      expect(subject.contains?(region)).to be_truthy
    end

    it 'returns falsey when it does not contain the given country' do
      expect(subject.contains?(:gb)).to be_truthy
    end
  end

  describe '#countries' do
    let(:country) { instance_double(Regionite::Country, code: 'us',
      name: 'United States') }
    subject { super().new(name: 'North America',
      country_codes: ['us']).countries }

    it 'returns an array' do
      expect(subject).to be_an(Array)
    end

    it 'returns an array of country objects' do
      expect(subject.first).to be_a(Regionite::Country)
    end

    it 'returns the countries in the region' do
      expect(subject.first.code).to contain_exactly(country.code)
    end
  end

  describe '#name' do
    subject { super().new(name: 'North America',
      country_codes: ['us', 'ca', 'mx']).name }

    it 'returns a string' do
      expect(subject).to be_a(String)
    end

    it 'returns the name of the region' do
      expect(subject.to_s).to eq('North America')
    end
  end

  describe '#slug' do
    subject { super().new(name: 'Oceania', country_codes: ['au']).slug }

    it 'returns a symbol' do
      expect(subject).to be_a(Symbol)
    end

    it 'returns the slug of the region' do
      expect(subject.to_sym).to eq(:oceania)
    end

    context 'when the name contains spaces' do
      subject { Regionite::Region.new(name: 'North America',
        country_codes: ['us', 'ca', 'mexico']).slug }

      it 'underscores the name' do
        expect(subject.to_sym).to eq(:north_america)
      end
    end
  end

  describe '#type' do
    subject { super().new(name: 'North America', type: :continent).type }

    it 'returns a symbol' do
      expect(subject).to be_a(Symbol)
    end

    it 'returns the type of region' do
      expect(subject.to_sym).to be(:continent)
    end
  end
end
