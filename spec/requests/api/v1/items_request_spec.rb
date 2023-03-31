require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    merchant = create(:merchant)
    create_list(:item, 3, merchant_id: merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

    items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:name]).to be_a(String)
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_a(Integer)
    end
  end

  it 'can get one item by its id' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}"

    expect(response.status).to eq(200)

    item_data = JSON.parse(response.body, symbolize_names: true)

    expect(item_data[:data]).to have_key(:id)
    expect(item_data[:data][:id]).to eq "#{item.id}"
    expect(item_data[:data][:attributes]).to have_key(:description)
    expect(item_data[:data][:attributes][:description]).to eq item.description
    expect(item_data[:data][:attributes]).to have_key(:unit_price)
    expect(item_data[:data][:attributes][:unit_price]).to eq item.unit_price
    expect(item_data[:data][:attributes]).to have_key(:merchant_id)
    expect(item_data[:data][:attributes][:merchant_id]).to eq item.merchant_id
  end

  it 'returns an error if the item does not exist' do
    get "/api/v1/items/1"

    no_item = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(no_item[:errors].first[:title]).to eq("Couldn't find Item with 'id'=1")
    expect(no_item[:errors].first[:status]).to eq("404")
  end

  describe '#create' do 
    it 'can create a new item' do
      merchant = create(:merchant)
      post "/api/v1/items" , params: { name: "New Item", description: "New Description", unit_price: 100.0, merchant_id: merchant.id }
      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(201)
      expect(item_data[:data][:attributes].keys).to eq [:name, :description, :unit_price, :merchant_id]
      expect(item_data[:data][:attributes][:name]).to eq("New Item")
    end

    it 'returns an error if the item is not created' do
      merchant = create(:merchant)
      post "/api/v1/items" , params: { name: "New Item", description: "New Description", merchant_id: merchant.id }
      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(422)
      expect(item_data[:errors].first[:title]).to eq("Validation failed: Unit price can't be blank, Unit price is not a number")
    end

    it "can ignore attributes that are not relavant to item" do
      merchant = create(:merchant)
      item_atts = { name: "New Item", description: "New Description", unit_price: 100.0, merchant_id: merchant.id, other_param: "test" }
      post "/api/v1/items", params: item_atts

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(201)
      expect(item_data[:data][:attributes].keys).to eq([:name, :description, :unit_price, :merchant_id])
      expect(item_data[:data][:attributes].keys).not_to include(:other_param)
      expect(item_data[:data][:attributes][:name]).to eq(item_atts[:name])
    end
  end

  describe '#update' do
    it 'can update an existing item' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      previous_name = item.name
      item_params = { name: "New Item Name" }

      patch "/api/v1/items/#{item.id}", params: item_params

      item_data = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(item_data[:data][:attributes][:name]).to_not eq(previous_name)
      expect(item_data[:data][:attributes][:name]).to eq "New Item Name"
    end

    it 'returns an error if the item is not updated' do
      merchant = create(:merchant)
      item = create(:item, merchant_id: merchant.id)
      item_params = { unit_price: "not a number" }
      patch "/api/v1/items/#{item.id}", params: item_params

      item_data = JSON.parse(response.body, symbolize_names: true)
      expect(response.status).to eq(422)
      expect(item_data[:errors].first[:title]).to eq("Validation failed: Unit price is not a number")
    end
  end

  it 'can delete an item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response.status).to eq(200)
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can return the merchant associated with an item' do
    merchant = create(:merchant)
    item = create(:item, merchant_id: merchant.id)

    get "/api/v1/items/#{item.id}/merchant"
    merchant_data = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(merchant_data[:data][:attributes][:name]).to eq(merchant.name)
  end

  describe 'Find Endpoints' do
    describe 'Find by name' do
      before :each do
        merchant = create(:merchant)
        @item1 = create(:item, merchant: merchant, name: "Item 1")
        @item2 = create(:item, merchant: merchant, name: "Item 2")
        @item3 = create(:item, merchant: merchant, name: "Item 3")
      end

      it 'can find an item by name' do
        get "/api/v1/items/find_all?name=#{@item1.name}"

        expect(response.status).to eq(200)
        item_search = JSON.parse(response.body, symbolize_names: true)
        expect(item_search[:data]).to be_a(Array)
        expect(item_search[:data].first[:attributes][:name]).to eq(@item1.name)
      end

      it 'returns all paratial matches' do
        get "/api/v1/items/find_all?name=item"

        expect(response.status).to eq(200)
        item_search = JSON.parse(response.body, symbolize_names: true)
        expect(item_search[:data].count).to be(3)
        expect(item_search[:data].first[:attributes][:name]).to eq(@item1.name)
        expect(item_search[:data].last[:attributes][:name]).to eq(@item3.name)
      end

      it 'returns an empty array if no matches are found' do
        get "/api/v1/items/find_all?name=notanitem"

        expect(response.status).to eq(200)
        item_search = JSON.parse(response.body, symbolize_names: true)
        expect(item_search[:data]).to be_a(Array)
        expect(item_search[:data]).to eq([])
      end
    end
    describe 'Find by price range' do
      it 'can find all items within a price range' do
        merchant = create(:merchant)
        item_1 = create(:item, merchant: merchant, unit_price: 1.00)
        item_2 = create(:item, merchant: merchant, unit_price: 2.00)
        item_3 = create(:item, merchant: merchant, unit_price: 3.00)
        item_4 = create(:item, merchant: merchant, unit_price: 4.00)
        item_5 = create(:item, merchant: merchant, unit_price: 5.00)

        get "/api/v1/items/find_all?min_price=2.00&max_price=4.00"

        item_search = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(200)
        expect(item_search[:data].count).to eq(3)
        expect(item_search[:data].first[:attributes][:name]).to eq(item_2.name)
        expect(item_search[:data].second[:attributes][:name]).to eq(item_3.name)
        expect(item_search[:data].third[:attributes][:name]).to eq(item_4.name)
      end
    end
  end
end