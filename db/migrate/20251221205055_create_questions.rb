class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.references :survey, null: false, foreign_key: true
      t.string :content
      t.integer :question_type, default: 0 # 0 - radio по умолчанию
      t.text :options # Здесь будем хранить варианты ответов через Enter

      t.timestamps
    end
  end
enddu
