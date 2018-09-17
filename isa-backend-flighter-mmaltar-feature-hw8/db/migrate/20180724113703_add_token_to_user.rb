class AddTokenToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :token, :string, null: false, default: ''
    User.all.each do |user|
      user.regenerate_token
      user.save
    end
    add_index :users, :token, unique: true
  end

  def down
    remove_column :users, :token
  end

end
