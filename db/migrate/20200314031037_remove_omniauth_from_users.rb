class RemoveOmniauthFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
    remove_column :users, :name, :string
    remove_column :users, :image, :text
  end
end
