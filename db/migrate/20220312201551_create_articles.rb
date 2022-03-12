class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :name
      t.text :content
      t.belongs_to :book

      t.timestamps
    end
  end
end
