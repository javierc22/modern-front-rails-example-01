class CreateShoppingCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :shopping_carts do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    change_table :tickets do |t|
      t.references :shopping_carts, null: true, foreign_key: true
    end

    change_table :ticket_orders do |t|
      t.references :shopping_carts, null: true, foreign_key: true
    end
  end
end
