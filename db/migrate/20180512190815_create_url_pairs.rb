class CreateUrlPairs < ActiveRecord::Migration[5.1]
  def change
    create_table :url_pairs do |t|
      t.string :original
      t.string :shortened
      t.integer :visits_count, default: 0
      t.string :user_token
      t.timestamps
    end
  end
end
