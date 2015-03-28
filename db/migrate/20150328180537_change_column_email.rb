class ChangeColumnEmail < ActiveRecord::Migration
  def change
    change_column :users, :email, :string, null: true
    add_column :users, :team_url, :string
    add_column :users, :nickname, :string
    add_column :users, :team, :string
    add_column :users, :team_id, :string
  end
end
