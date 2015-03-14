require 'rails_helper'

RSpec.describe RemotePackage, type: :model do
  let(:package_name) { 'A3' }
  let(:package_version) { '0.9.2' }
  let(:package_full_name) { "#{package_name}_#{package_version}" }
  let(:package_title) { 'A3: Accurate, Adaptable, and Accessible Error Metrics for Predictive Models' }
  let(:package_description) { 'This package supplies tools for tabulating and analyzing the results of predictive models. The methods employed are applicable to virtually any predictive model and make comparisons between different methodologies straightforward.' }
  let(:package_published_at) { '2013-03-26 19:58:40' }
  let(:remote_package) { RemotePackage.new package_name, package_version }

  describe '.all', :vcr do
    it 'should parse packges' do
      packages = RemotePackage.all
      package = packages.first

      expect(packages).to be_present
      expect(package).to be_kind_of RemotePackage
      expect(package.name).to eql package_name
      expect(package.version).to eql package_version
    end
  end

  describe '#full_name' do
    subject { remote_package }

    its(:full_name) { is_expected.to eql package_full_name }
  end

  describe '#details', :vcr do
    it 'should parse additional details' do
      details = remote_package.details

      expect(details).to include 'Title' => package_title
      expect(details).to include 'Description' => package_description
      expect(details).to include 'Date/Publication' => package_published_at
    end

    it 'should raise error if no DESCRIPTION found' do
      allow_any_instance_of(Gem::Package::TarReader).to receive(:seek).and_return nil

      expect{remote_package.details}.to raise_error
    end
  end

  describe '#title', :vcr do
    subject { remote_package }

    its(:title) { is_expected.to eql package_title }
  end

  describe '#description', :vcr do
    subject { remote_package }

    its(:description) { is_expected.to eql package_description }
  end

  describe '#published_at', :vcr do
    subject { remote_package }

    its(:published_at) { is_expected.to be_kind_of DateTime }
  end

  describe '#to_hash', :vcr do
    subject { remote_package.to_hash }

    it do
      is_expected.to include name: package_name
      is_expected.to include version: package_version
      is_expected.to include full_name: package_full_name
      is_expected.to include title: package_title
      is_expected.to include description: package_description
      is_expected.to include published_at: DateTime.parse(package_published_at)
    end
  end
end
