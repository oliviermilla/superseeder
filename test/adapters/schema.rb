ActiveRecord::Schema.define do

  create_table :parkings do |t|
    t.string  :name
    t.integer :size
  end

  create_table :cars do |t|
    t.string :name
    t.references :parking
  end

end