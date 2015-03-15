require 'rails_helper'

RSpec.describe Package, type: :model do
  it { should have_many :versions }

  it { should belong_to :latest_version }

  describe '.except_existing' do
    let(:package_full_name) { 'A3_1.1.1' }
    let(:remote_package) { double full_name: package_full_name }

    it 'should return not existing remote packages' do
      not_existing = Package.except_existing [remote_package]

      expect(not_existing).to have(1).item
      expect(not_existing.first).to eql remote_package
    end

    it 'should not return existing remote packages' do
      create :package, full_name: package_full_name

      not_existing = Package.except_existing [remote_package]

      expect(not_existing).to be_blank
    end

    it 'should yield every not existing item' do
      expect { |b| Package.except_existing [remote_package], &b }.to yield_with_args remote_package
    end
  end

  describe '.create_from_remote' do
    let(:remote_package) do
      double(
        name: 'A3',
        full_name: 'A3_0.9.2',
        to_hash: {
          version: '0.9.2',
          title: 'Title',
          description: 'Description',
          published_at: DateTime.current,
          authors: [{ name: 'Ev Fjord', email: nil }],
          maintainers: [{ name: 'Ev Fjord', email: 'ev@fjord.com' }]
        }
      )
    end

    it 'should create package and version from remote package' do
      Package.create_from_remote remote_package

      expect(Package.all).to have(1).item
      expect(Version.all).to have(1).item

      package = Package.first
      version = Version.first

      expect(package.name).to eql remote_package.name
      expect(package.full_name).to eql remote_package.full_name
      expect(package.latest_version).to eql version

      expect(version.package).to eql package
      expect(version.version).to eql remote_package.to_hash[:version]
      expect(version.title).to eql remote_package.to_hash[:title]
      expect(version.description).to eql remote_package.to_hash[:description]
      expect(version.published_at.to_s(:db)).to eql remote_package.to_hash[:published_at].to_s(:db)
      expect(version.authors).to eql remote_package.to_hash[:authors]
      expect(version.maintainers).to eql remote_package.to_hash[:maintainers]
    end

    it 'should update existing packge' do
      create :package, name: remote_package.name

      Package.create_from_remote remote_package

      expect(Package.all).to have(1).item
      expect(Version.all).to have(1).item
    end
  end
end
