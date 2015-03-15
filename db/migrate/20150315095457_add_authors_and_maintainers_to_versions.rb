class AddAuthorsAndMaintainersToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :authors, :text
    add_column :versions, :maintainers, :text
  end
end
