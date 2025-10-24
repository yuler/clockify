class CreateTaskEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :task_entries do |t|
      t.references :task, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :operation, null: false, default: 'increment', limit: 20
      t.decimal :value, precision: 10, scale: 2, null: false
      t.decimal :value_before, precision: 10, scale: 2, null: false
      t.decimal :value_after, precision: 10, scale: 2, null: false
      t.text :description

      t.timestamps
    end

    add_index :task_entries, [ :task_id, :created_at ]
    add_index :task_entries, [ :user_id, :created_at ]
    add_index :task_entries, :created_at
  end
end
