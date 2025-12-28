class AddUserToSubmissions < ActiveRecord::Migration[8.1]
  def change
    add_reference :submissions, :user, null: false, foreign_key: true
  end
end
