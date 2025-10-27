class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :emoji, limit: 8
      t.string :background, limit: 7
      t.string :name, null: false, limit: 20
      t.text :slogan
      t.string :status, null: false, default: "active", limit: 20
      t.references :taskable, polymorphic: true, null: false, index: true

      t.timestamps
    end

    add_index :tasks, [ :user_id, :status ]
    add_index :tasks, [ :user_id, :taskable_type ]
  end
end
