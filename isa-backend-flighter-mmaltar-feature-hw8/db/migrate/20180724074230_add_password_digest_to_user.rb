class AddPasswordDigestToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :password_digest, :string
    User.all.each do |user|
      user.password = 'password'
      user.save
    end
  end

  def down
    remove_column :users, :password_digest
  end
end
