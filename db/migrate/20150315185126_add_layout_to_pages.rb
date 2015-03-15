class AddLayoutToPages < ActiveRecord::Migration
  def change
    add_column :pages, :layout_name, :string
    add_column :pages, :custom_layout_content, :text
  end
end
