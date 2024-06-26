class CreateApprovals < ActiveRecord::Migration[7.1]
  def change
    create_table :approvals do |t|
      t.decimal :approved_amount, precision: 10, scale: 2
      t.string :status
      t.datetime :approved_at
      t.datetime :confirmed_at
      t.integer :confirmed_by_id
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
