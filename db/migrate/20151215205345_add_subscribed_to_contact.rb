class AddSubscribedToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :subscribed, :boolean
  end
end
