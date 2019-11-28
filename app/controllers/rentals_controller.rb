class RentalsController < ApplicationController
  before_action :set_rental, only: %i[confirm]
  before_action :authorize_user!, only: %i[confirm]

  def index
    @rentals = Rental.where(subsidiary: current_subsidiary)
  end

  def new
    @rental = Rental.new
    @clients = Client.all
    @categories = Category.all
  end

  def create
    @rental = RentalBuilder.new(rental_params, current_subsidiary).build
      return redirect_to rental_path(@rental.id) if @rental.save

      @clients = Client.all
      @categories = Category.all
      render :new
  end

  def confirm
    @rental = Rental.find(params[:id])
    @car = Car.find_by(id: params[:car_id])
    if RentalConfirmer.new(@rental, @car, params[:addon_ids]).confirm
      render :confirm
    else
      flash[:danger] = "Carro deve ser selecionado"
      @cars = @rental.available_cars
      @addons = Addon.joins(:addon_items).where(addon_items: { status: :available  }).group(:id)
      render :review
    end
  end

  def show
    @rental = RentalPresenter.new(Rental.find(params[:id]))
  end

  def search
    @rental = Rental.find_by(reservation_code: params[:q])
    return redirect_to review_rental_path(@rental) if @rental
  end

  def review
    @rental = Rental.find(params[:id])
    @rental.in_review!
    @cars = @rental.available_cars
    @addons = Addon.joins(:addon_items).where(addon_items: { status: :available  }).group(:id)
  end

  def start
    @rental = Rental.find(params[:id])
    @rental.ongoing!
    redirect_to @rental
  end
  private

  def rental_params
    params.require(:rental).permit(:category_id, :client_id, :start_date,
                                   :end_date,
                                   rental_items_attributes: [:car_id])
  end

  def set_rental
    @rental = Rental.find(params[:id])
  end

  def authorize_user!
    return if authorized?

    redirect_to @rental
  end

  def authorized?
    RentalAuthorizer.new(@rental, current_user).authorized?
  end
end
