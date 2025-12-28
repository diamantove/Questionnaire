class CreateSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_table :submissions do |t|
      t.references :survey, null: false, foreign_key: true

      t.timestamps
    end
  end
end
