class CreateOmgImageImages < ActiveRecord::Migration[5.2]
  def change
    create_table :omg_image_images do |t|
      t.string :key, index: true, unique: true
      t.datetime :created_at
    end
  end
end
