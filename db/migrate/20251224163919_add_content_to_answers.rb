class AddContentToAnswers < ActiveRecord::Migration[8.1]
  def change
    add_column :answers, :content, :text
  end
end
