class RentalConfirmer
  attr_reader :rental, :car, :addon_ids

  def initialize(rental, car, addon_ids = [])
    @rental = rental
    @car = car
    @addon_ids = addon_ids
  end

  def confirm
    return false if car.nil?

    create_rental_item(car, car.daily_rate)
    create_rental_addon_items
    update_price
    rental
  end

  private

  def create_rental_item(item, daily_rate)
    rental.rental_items.create(rentable: item, daily_rate: daily_rate)
  end

  def create_rental_addon_items
    addons = Addon.where(id: addon_ids)
    return unless addons

    addon_items = addons.map { |addon| addon.first_available_item }
    addon_items.each do |addon_item|
      rental.rental_items.create(rentable: addon_item, daily_rate: addon_item.addon.daily_rate)
    end
  end

  def update_price
    rental.update(price_projection: rental.calculate_final_price)
  end
end
