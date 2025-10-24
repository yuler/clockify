class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :type, null: false
      t.string :name, null: false, limit: 100
      t.text :slogan
      t.string :theme_emoji, limit: 10
      t.string :theme_color, limit: 7
      t.decimal :target_value, precision: 10, scale: 2
      t.decimal :current_value, precision: 10, scale: 2, default: 0, null: false
      t.decimal :step_value, precision: 10, scale: 2, default: 1, null: false
      t.string :step_unit, limit: 50
      t.string :cycle_reset_type, default: 'none', null: false, limit: 20
      t.integer :cycle_reset_days
      t.date :cycle_reset_next_on
      t.datetime :cycle_reset_last_at # 最后一次重置时间
      t.string :status, default: 'active', null: false, limit: 20
      t.datetime :completed_at

      t.timestamps
    end

    add_index :tasks, [ :user_id, :status ]
    add_index :tasks, [ :user_id, :type ]
    add_index :tasks, :cycle_reset_next_on
  end
end
