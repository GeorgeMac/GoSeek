class AddStarsToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :stars, :integer
  end
end
