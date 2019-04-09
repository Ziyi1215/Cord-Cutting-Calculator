class AddAntennaToChannel < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :antenna, :string
  end
end
