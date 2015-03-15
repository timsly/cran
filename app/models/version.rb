class Version < ActiveRecord::Base
  belongs_to :package

  serialize :authors, Array
  serialize :maintainers, Array
end
