class ImagesController < ApplicationController
  before_action :set_image, only: %i[ show edit update destroy ]
  before_action :set_user, only: [:redirect, :index, :show, :new, :edit, :update, :destroy, :destroy_all ]
  before_action :redirect, only: [:edit, :update, :destroy]

  def redirect 
    if @current_user.id != @image.user_id
      redirect_to images_url
    end
  end

  # GET /images or /images.json
  def index

    @public_images = Image.public_images(params[:search], @current_user.id)
    @user_images = Image.user_images(params[:search], @current_user.id)
    
    @images = @public_images + @user_images
  end

  # GET /images/1 or /images/1.json
  def show

  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images or /images.json
  def create
    @image = Image.new(image_params)

    @image.user = current_user

    if @image.discount == nil
      @image.discount = 0
    end
    if @image.price == nil
      @image.price = 0
    end
    if @image.inventory == nil
      @image.inventory = 1
    end

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: "Image was successfully created." }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1 or /images/1.json
  def update
    if @current_user.id == @image.user_id
      respond_to do |format|
        if @image.update(image_params)
          format.html { redirect_to @image, notice: "Image was successfully updated." }
          format.json { render :show, status: :ok, location: @image }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @image.errors, status: :unprocessable_entity }
        end
      end
    else 
      respond_to do |format|
        format.html { redirect_to images_url, notice: "You are not allowed to edit this image." }
        format.json { head :no_content }
      end
    end 
  end

  # DELETE /images/1 or /images/1.json
  def destroy
    if @current_user.id == @image.user_id
      @image.destroy
      respond_to do |format|
        format.html { redirect_to images_url, notice: "Image was successfully destroyed." }
        format.json { head :no_content }
      end
    else 
      respond_to do |format|
        format.html { redirect_to images_url, notice: "You are not allowed to delete this image." }
        format.json { head :no_content }
      end
    end
  end

  def destroy_all
    Image.where(user_id: current_user.id).destroy_all
    respond_to do |format|
      format.html { redirect_to images_url, notice: "Images were successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    def set_user
      @current_user = current_user
    end
    # Only allow a list of trusted parameters through.
    def image_params
      params.require(:image).permit(:description, :price, :discount, :tags, :private, :main_image, :inventory, :search)
    end
end
