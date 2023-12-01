class AddContentToRecipes < ActiveRecord::Migration[7.1]
  def change
    add_column :recipes, :content, :text
  end
end
