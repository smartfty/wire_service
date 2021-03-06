class CreateYhPictures < ActiveRecord::Migration[5.2]
  def change
    create_table :yh_pictures do |t|
      t.string :action
      t.string :service_type
      t.string :content_id
      t.date :date
      t.time :time
      t.string :urgency
      t.string :category
      t.string :class_code
      t.string :attriubute_code
      t.string :source
      t.string :credit
      t.string :region
      t.string :title
      t.string :subtile
      t.string :body
      t.string :picture
      t.string :taken_by
      t.boolean :selected
      t.string :group
      t.string :page

      t.timestamps
    end
  end
end
