class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.belongs_to :package, index: true
      t.string :version
      t.string :title
      t.text :description
      t.datetime :published_at

      t.timestamps null: false
    end
  end
end
