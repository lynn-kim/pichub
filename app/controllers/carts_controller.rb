class CartsController < ApplicationController
  before_action :set_cart
  before_action :get_cart_items, only: [:show, :calculate_price]

  # GET /carts or /carts.json
  def index
    redirect_to @cart
  end

  # GET /carts/1 or /carts/1.json
  def show
    @subtotal = calculate_price
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # PATCH/PUT /carts/1 or /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: "Cart was successfully updated." }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1 or /carts/1.json
  def destroy
    @cart.destroy
    respond_to do |format|
      format.html { redirect_to carts_url, notice: "Cart was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def add_image
    @image = Image.find(params[:image_id])
    if @image.inventory > 0 
      @image.carts << @cart
      @image.inventory -= 1
      @image.save
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "Image added to cart" }
        format.json { head :no_content }
      end
    else 
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "Image is out of stock" }
        format.json { head :no_content }
      end
    end
  end

  def remove_image
    delete_query = "DELETE FROM carts_images WHERE image_id = #{params[:image_id]} AND ctid IN (SELECT ctid FROM carts_images WHERE image_id = 1 LIMIT 1)"
    ActiveRecord::Base.connection.execute(delete_query)
    if @cart.save 
      @image = Image.find(params[:image_id])
      @image.inventory += 1
      @image.save
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "Image removed from cart" }
        format.json { head :no_content }
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      if Cart.where(user_id: current_user.id).exists?
        @cart = Cart.find_by_user_id(current_user.id)
      else 
        @cart = Cart.new
        @cart.user_id = current_user.id
        @cart.save
      end
    end

    def get_cart_items
      @cart_items = @cart.images
    end
    # Only allow a list of trusted parameters through.
    def cart_params
      params.require(:cart).permit(:image_id)
    end

    def calculate_price
      @price = 0
      @cart_items.each do |item|
        @price += item.price * (1.00 - (item.discount / 100.00))
      end
      @price
    end
    
end
