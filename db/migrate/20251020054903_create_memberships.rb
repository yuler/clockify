class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_enum :membership_role, %w[member administrator]

    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true
      t.enum :role, enum_type: :membership_role, default: 'member'

      t.timestamps
    end
  end
end
