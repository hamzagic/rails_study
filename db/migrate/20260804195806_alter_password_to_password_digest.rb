class AlterPasswordToPasswordDigest < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :password_digest, :string
    remove_column :users, :password, :string
  end
end
