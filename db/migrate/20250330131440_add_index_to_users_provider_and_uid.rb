class AddIndexToUsersProviderAndUid < ActiveRecord::Migration[8.0]
  def change
    add_index :users, [:provider, :uid], unique: true
  end
end
