require 'rails_helper'

feature 'Packages', type: :feature do
  let(:version) { create :version, version: '0.0.1', title: 'A3 title', description: 'A3 description', published_at: DateTime.current }
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
  end
end
