class CarModelDecorator < Draper::Decorator
  delegate_all

  def photo
    return super if super.attached?

    'https://via.placeholder.com/350x150'
  end

  def car_options
    return [] if super.blank?

    super.split(',')
  end
end
