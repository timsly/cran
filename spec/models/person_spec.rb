require 'rails_helper'

RSpec.describe Person, type: :model do
  describe '.create_from_hashes' do
    let(:hashes) do
      [
        { name: 'Ev Fjord', email: 'ev@fjord.com' },
        { name: 'April McDonald' }
      ]
    end

    it 'should create people from array of hashes' do
      Person.create_from_hashes hashes

      expect(Person).to have(2).items

      with_email = Person.find_by(name: 'Ev Fjord')
      expect(with_email).to be_present
      expect(with_email.email).to eql 'ev@fjord.com'

      with_name_only = Person.find_by(name: 'April McDonald')
      expect(with_name_only).to be_present
      expect(with_name_only.email).to be_blank
    end

    it 'should return existing person with email match' do
      with_email = create :person, email: 'ev@fjord.com'

      Person.create_from_hashes hashes

      expect(Person).to have(2).items
      expect(Person.all).to include with_email
    end

    it 'should return existing person with name match' do
      with_name_only = create :person, name: 'April McDonald', email: 'some@email.com'

      Person.create_from_hashes hashes

      expect(Person).to have(2).items
      expect(Person.all).to include with_name_only
    end
  end
end
