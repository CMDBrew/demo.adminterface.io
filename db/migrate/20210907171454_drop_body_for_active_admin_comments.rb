class DropBodyForActiveAdminComments < ActiveRecord::Migration[6.1]
  def up
    rename_column :active_admin_comments, :body, :body_backup

    ## Add migration to migrate existing data if necessary
    # ActiveAdmin::Comment.reset_column_information
    # ActiveAdmin::Comment.find_each do |comment|
    #   comment.body = comment.body_backup
    #   comment.save
    # end

    remove_column :active_admin_comments, :body_backup, :text
  end

  def down
    add_column :active_admin_comments, :body_backup, :text

    ## Add migration to migrate existing data if necessary
    # ActiveAdmin::Comment.reset_column_information
    # ActiveAdmin::Comment.find_each do |comment|
    #   comment.body_backup = comment.body.to_plain_text
    #   comment.save
    # end

    rename_column :active_admin_comments, :body_backup, :body
  end
end
