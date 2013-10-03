class AddForksToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :forks, :integer
  end
end
