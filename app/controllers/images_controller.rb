class ImagesController < ApplicationController
  before_action :set_image, only: %i[ show edit update destroy ]
  before_action :set_user, only: [:index, :show, :new, :edit, :destroy_all ]

  # GET /images or /images.json
  def index
    @public_images = Image.where(private: false).where.not(user_id: current_user)
    @user_images = Image.where(user_id: current_user.id)
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
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to @image, notice: "Image was successfully updated." }
        format.json { render :show, status: :ok, location: @image }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1 or /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: "Image was successfully destroyed." }
      format.json { head :no_content }
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
      params.require(:image).permit(:description, :price, :discount, :tags, :private, :main_image, :inventory)
    end
end
