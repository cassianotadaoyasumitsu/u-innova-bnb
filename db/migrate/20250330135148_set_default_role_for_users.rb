class SetDefaultRoleForUsers < ActiveRecord::Migration[8.0]
  def change
    # Set default role for existing users who don't have a role
    User.where(role: nil).update_all(role: "guest")
    
    # Change the column to have a default value
    change_column_default :users, :role, "guest"
  end
end
