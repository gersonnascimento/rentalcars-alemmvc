require 'rails_helper'

describe RentalByCategoryAndSubsidiaryQuery do
  describe '.call' do
    it 'should filter by category' do

      subsidiary = create(:subsidiary, name: 'Almeida Motors')
      other_subsidiary = create(:subsidiary, name: 'Outra Almeida Motors')

      category_a = create(:category, name: 'A', daily_rate: 10, car_insurance: 20,
                        third_party_insurance: 20)
      category_b = create(:category, name: 'B', daily_rate: 10, car_insurance: 20,
                                          third_party_insurance: 20)

      create_list(:car, 10, category: category_a)
      create_list(:car, 10, category: category_b)

      customer = create(:individual_client, name: 'Gerson', cpf: '423.777.866-43',email: 'xablau@hotmail.com')

      create(:rental, category: category_a,
                      subsidiary: subsidiary,
                      start_date: '2019-01-08',
                      end_date: '2019-01-10',
                      client: customer,
                      price_projection: 10)

      create(:rental, category: category_b,
                      subsidiary: subsidiary,
                      start_date: '2019-01-08',
                      end_date: '2019-01-10',
                      client: customer,
                      price_projection: 10)

      create(:rental, category: category_b,
                      subsidiary: subsidiary,
                      start_date: '2019-01-08',
                      end_date: '2019-01-10',
                      client: customer, price_projection: 10)

      create(:rental, category: category_b,
                      subsidiary: other_subsidiary,
                      start_date: '2019-01-08',
                      end_date: '2019-01-10',
                      client: customer, price_projection: 10)

      create(:rental, category: category_a,
                      subsidiary: other_subsidiary,
                      start_date: '2019-01-08',
                      end_date: '2019-01-10',
                      client: customer, price_projection: 10)

      create(:rental, category: category_a,
                      subsidiary: other_subsidiary,
                      start_date: '2019-01-08',
                      end_date: '2019-01-10',
                      client: customer, price_projection: 10)


    start_date = '2019-01-01'
    end_date = '2020-12-12'

    expect(described_class.new(start_date, end_date).call.first['subsidiary']).to eq('Almeida Motors')
    expect(described_class.new(start_date, end_date).call.first['category']).to eq('A')
    expect(described_class.new(start_date, end_date).call.first['total']).to eq(1)

    expect(described_class.new(start_date, end_date).call.second['subsidiary']).to eq('Almeida Motors')
    expect(described_class.new(start_date, end_date).call.second['category']).to eq('B')
    expect(described_class.new(start_date, end_date).call.second['total']).to eq(2)

    expect(described_class.new(start_date, end_date).call.third['subsidiary']).to eq('Outra Almeida Motors')
    expect(described_class.new(start_date, end_date).call.third['category']).to eq('A')
    expect(described_class.new(start_date, end_date).call.third['total']).to eq(2)

    expect(described_class.new(start_date, end_date).call.fourth['subsidiary']).to eq('Outra Almeida Motors')
    expect(described_class.new(start_date, end_date).call.fourth['category']).to eq('B')
    expect(described_class.new(start_date, end_date).call.fourth['total']).to eq(1)
    end
  end
end
