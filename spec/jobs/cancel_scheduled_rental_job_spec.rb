require 'rails_helper'

describe CancelScheduledRentalsJob do
  describe '.auto_enqueue' do
    it 'should auto enqueue' do
      described_class.auto_enqueue(Time.zone.now)
      expect(Delayed::Worker.new.work_off).to eq [1,0]
    end
  end

  describe '.perform' do
    it 'should cancel overpast rentals' do
      subsidiary = create(:subsidiary, name: 'Almeida Motors')

      category = create(:category, name: 'A', daily_rate: 10, car_insurance: 20,
                        third_party_insurance: 20)

      customer = create(:individual_client, name: 'Gerson', cpf: '423.777.866-43',email: 'xablau@hotmail.com')

      create_list(:car, 10, category: category)

      old_rental = create(:rental, category: category,
                                   subsidiary: subsidiary,
                                   start_date: 10.days.ago,
                                   end_date: 5.days.ago,
                                   client: customer,
                                   price_projection: 10,
                                   status: :scheduled)

     future_rental = create(:rental, category: category,
                                  subsidiary: subsidiary,
                                  start_date: 1.day.from_now,
                                  end_date: 2.days.from_now,
                                  client: customer,
                                  price_projection: 10,
                                  status: :scheduled)

      described_class.auto_enqueue(Time.zone.now)

      Delayed::Worker.new.work_off
      old_rental.reload
      future_rental.reload

      expect(old_rental).to be_canceled
      expect(future_rental).to be_scheduled
    end
  end
end
