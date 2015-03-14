class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name
      t.string :full_name
      t.belongs_to :latest_version, index: true

      t.timestamps null: false
    end
  end
end
