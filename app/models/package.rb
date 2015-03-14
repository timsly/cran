class Package < ActiveRecord::Base
  has_many :versions, dependent: :destroy
  belongs_to :latest_version, class_name: 'Version'

  class << self
    def except_existing(remote_packages)
      existing = all.where(full_name: remote_packages.map(&:full_name)).pluck :full_name

      result = []
      remote_packages.each do |package|
        unless existing.include? package.full_name
          yield package if block_given?
          result << package
        end
      end
      result
    end

    def create_from_remote(remote_package)
      package = all.find_or_initialize_by name: remote_package.name
      package.latest_version = package.versions.new remote_package.to_hash.slice(
        :version, :title, :description, :published_at
      )
      package.full_name = remote_package.full_name
      package.save!
    end
  end
end
