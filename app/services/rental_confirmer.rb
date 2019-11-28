class RentalConfirmer
  attr_reader :rental, :car, :addon_ids

  def initialize(rental, car, addon_ids = [])
    @rental = rental
    @car = car
    @addon_ids = addon_ids
  end

  def confirm
    return false if car.nil?

    total_daily_hate = (car.category.daily_rate +
                        car.category.third_party_insurance +
                        car.category.car_insurance)

    create_rental_item(car,total_daily_hate)

    if addons = Addon.where(id: addon_ids)
      addon_items = addons.map { |addon| addon.first_available_item }
      addon_items.each do |addon_item|
        rental.rental_items.create(rentable: addon_item, daily_rate: addon_item.addon.daily_rate)
      end
    end
    rental.update(price_projection: rental.calculate_final_price)
    rental
  end

  def create_rental_item(item, daily_rate)
    rental.rental_items.create(rentable: item, daily_rate: daily_rate)
  end
end
