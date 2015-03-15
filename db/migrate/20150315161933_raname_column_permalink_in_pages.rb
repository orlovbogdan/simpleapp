class RanameColumnPermalinkInPages < ActiveRecord::Migration
  def change
    rename_column :pages, :permalink, :slug
  end
end
