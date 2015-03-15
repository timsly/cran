class Person < ActiveRecord::Base
  class << self
    def create_from_hashes(hashes)
      with_email = []
      with_name = []

      hashes.each do |hash|
        if hash.key?(:email) && hash[:email].present?
          with_email << hash
        else
          with_name << hash
        end
      end

      create_from_hashes_by(:email, with_email) |
        create_from_hashes_by(:name, with_name)
    end

    private

    def create_from_hashes_by(field, hashes)
      data = hashes.map { |h| h[field] }

      existing = all.where(field => data).group_by { |p| p.send field }

      hashes.map do |hash|
        if existing.key? hash[field]
          existing[hash[field]].first
        else
          create! hash
        end
      end
    end
  end
end
