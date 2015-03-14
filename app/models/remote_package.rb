require 'open-uri'
require 'dcf'
require 'rubygems/package'
require 'zlib'

class RemotePackage
  SOURCE = 'http://cran.r-project.org/src/contrib/'

  attr_reader :name, :version

  def self.all
    list = open SOURCE + 'PACKAGES'
    list.read.scan(/Package:\s([^\n]+)\nVersion:\s([^\n]+)\n/).map do |match|
      new match[0], match[1]
    end
  end

  def initialize(name, version)
    @name = name
    @version = version
  end

  def full_name
    "#{name}_#{version}"
  end

  [:title, :description].each do |field|
    class_eval <<-CODE, __FILE__, __LINE__ + 1
      def #{field}
        @#{field} ||= details['#{field.to_s.titleize}']
      end
    CODE
  end

  def published_at
    @published_at ||= DateTime.parse(details['Date/Publication'])
  end

  def details
    @details ||= begin
      gz = Zlib::GzipReader.new open(SOURCE + "#{full_name}.tar.gz")
      tar = Gem::Package::TarReader.new gz
      tar.rewind
      description = tar.seek("#{name}/DESCRIPTION", &:read)
      raise('Cannot find DESCRIPTION') unless description
      Dcf.parse(description).first
    ensure
      gz.close
      tar.close
    end
  end

  def to_hash
    [:name, :version, :full_name, :title, :description, :published_at].each_with_object({}) do |field, memo|
      memo[field] = self.send field
    end
  end
end
