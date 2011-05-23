class CreateCells < ActiveRecord::Migration
  def self.up
    create_table :cells do |t|
      t.string(1) :type
    end
  end

  def self.down
    drop_table :cells
  end
end
