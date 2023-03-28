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

  it 'can create a new item' do
    merchant = create(:merchant)
    post "/api/v1/items" , params: { name: "New Item", description: "New Description", unit_price: 100.0, merchant_id: merchant.id }

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(200)
    expect(item[:data][:attributes].keys).to eq [:name, :description, :unit_price, :merchant_id]
    expect(item[:data][:attributes][:name]).to eq("New Item")
  end

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
end