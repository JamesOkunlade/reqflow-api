class CreateApprovalUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :approval_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :approval, null: false, foreign_key: true

      t.timestamps
    end
  end
end
