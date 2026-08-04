class CreateJwtDenylists < ActiveRecord::Migration[8.1]
  def change
    create_table :jwt_denylists, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.string :jti, null: false
      t.datetime :exp, null: false

      t.timestamps
    end
    add_index :jwt_denylists, :jti, unique: true
  end
end
