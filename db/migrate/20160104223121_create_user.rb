class CreateUser < ActiveRecord::Migration
  def change
  	create_table :users do |u|
  		u.string :fname
  		u.string :lname
  		u.string :email
  		u.string :password
  		u.string :username
  		u.timestamps null:false
  	end
  end
end
