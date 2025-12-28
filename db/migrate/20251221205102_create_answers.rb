class CreateAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :answers do |t|
      t.references :submission, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.text :value

      t.timestamps
    end
  end
end
