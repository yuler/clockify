class CreateNumericalTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :numerical_tasks do |t|
      t.decimal :value, precision: 10, scale: 2, default: 0.0, null: false
      t.string :value_unit, limit: 50

      t.timestamps
    end
  end
end
