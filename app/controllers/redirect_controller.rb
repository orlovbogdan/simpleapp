class RedirectController < ApplicationController
  def index
    page = Page.where('name LIKE ?', "#{params[:id].split('/').last}%").first
    redirect_to  view_context.page_path(page) #nested_page_path!!!проблема #page_path(page) #page
  end
end
