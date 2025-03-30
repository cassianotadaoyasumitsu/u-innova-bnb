class RemoveDefaultRoleFromUsers < ActiveRecord::Migration[8.0]
  def change
    # Remove default role from existing users
    User.where(role: nil).update_all(role: nil)
  end
end
