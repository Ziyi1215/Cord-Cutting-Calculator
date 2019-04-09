class AddSettopboxToChannels < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :settopbox, :string
  end
end
