require 'rails_helper'

feature 'Packages', type: :feature do
  let(:version) do
    create :version, version: '0.0.1', title: 'A3 title',
                     description: 'A3 description', published_at: DateTime.current,
                     authors: [{ name: 'Ev Fjord', email: nil }],
                     maintainers: [{ name: 'Ev Fjord', email: 'ev@fjord.com' }]
  end
  let!(:package) { create :package, name: 'A3', latest_version: version, versions: [version] }

  scenario 'Listing page' do
    visit root_path

    expect(page).to have_content package.name
    expect(page).to have_content version.version
    expect(page).to have_content version.title
  end

  scenario 'Details page' do
    visit root_path

    click_link package.name

    within '.package-details' do
      expect(page).to have_content package.name
      expect(page).to have_content version.version
      expect(page).to have_content version.title
      expect(page).to have_content version.description
    end

    within '.package-versions' do
      expect(page).to have_content version.version
      expect(page).to have_content version.published_at.to_s :long
    end

    within '.package-authors' do
      expect(page).to have_content version.authors.first[:name]
    end

    within '.package-maintainers' do
      expect(page).to have_content version.maintainers.first[:name]
      expect(page).to have_content version.maintainers.first[:email]
    end
  end
end
