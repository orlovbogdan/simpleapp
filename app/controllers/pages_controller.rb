class PagesController < ApplicationController
  #before_action :authenticate, except: :index

  before_action :page, only: [:show, :edit, :update, :destroy]

  layout :set_layout

  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    #self.class.layout(@page.layout_name || 'application')
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)
    @page.user = current_user

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    if request.xhr?
      page.name = params[:content][:page_name][:value]
      page.content = params[:content][:page_content][:value]
      page.save!
      return render text: ''
    end

    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def mercury_update
    page.name = params[:content][:page_name][:value]
    page.content = params[:content][:page_content][:value]
    page.save!
    render text: ''
  end

  private

    def set_layout
      ((params[:action] == 'show') && @page && @page.layout_name) || 'application'
    end
    # Use callbacks to share common setup or constraints between actions.
    def page
      @page ||= Page.find_by_slug!(params[:id].split('/').last)
      #@page ||= Page.find(params[:id])
    end
    helper_method :page

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:name, :slug, :content, :parent_id, :layout_name, :custom_layout_content)
    end

    def current_resource
      page
    end

end
