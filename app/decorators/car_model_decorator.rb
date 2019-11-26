class CarModelDecorator < Draper::Decorator
  delegate_all

  def photo
    'https://via.placeholder.com/350x150'
  end
end
