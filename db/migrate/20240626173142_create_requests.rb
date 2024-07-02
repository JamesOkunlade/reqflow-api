class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.string :title
      t.text :description
      t.bigint :amount_cents, null: false
      t.string :status, default: 'requested'
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
