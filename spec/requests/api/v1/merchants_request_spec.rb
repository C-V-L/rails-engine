require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(response.status).to eq(200)

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].count).to eq(3)
    merchants[:data].each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)
      expect(merchant).to have_key(:attributes)
      expect(merchant[:attributes]).to be_a(Hash)
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end
  
  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(response.status).to eq(200)

    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:id]).to be_a(String)
    expect(merchant[:data]).to have_key(:type)
    expect(merchant[:data][:type]).to be_a(String)
    expect(merchant[:data]).to have_key(:attributes)
    expect(merchant[:data][:attributes]).to be_a(Hash)
    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end

  it 'will return an error if the merchant does not exist' do
    get "/api/v1/merchants/1"

    no_merch = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(404)
    expect(no_merch[:errors].first[:title]).to eq("Couldn't find Merchant with 'id'=1")
  end

  it 'can return a collection of items associated with that merchant' do
    id = create(:merchant).id
    items = create_list(:item, 3, merchant_id: id)
    
    other_merchant = create(:merchant).id 
    other_items = create_list(:item, 3, merchant_id: other_merchant)

    get "/api/v1/merchants/#{id}/items"

    items_data = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 200
    expect(items_data[:data].count).to eq(3)
    expect(items_data[:data].first[:attributes][:name]).to eq(items.first.name)
    expect(items_data[:data].first[:attributes][:description]).to eq(items.first.description)
    expect(items_data[:data].first[:attributes][:unit_price]).to eq(items.first.unit_price)
    expect(items_data[:data].first[:attributes][:merchant_id]).to eq(items.first.merchant_id)
  end

  it 'can return a merchant based on search criteria' do
    merchant = create(:merchant, name: 'merchant')
    merchant2 = create(:merchant, name: 'merchant2')
    merchant3 = create(:merchant, name: 'merchant3')
    get '/api/v1/merchant/find?name=merchant'

    merchant_search = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 200
    expect(merchant_search[:data][:id]).to eq(merchant.id.to_s)
    expect(merchant_search[:data][:attributes][:name]).to eq('merchant')
  end

  it 'raises an error if no merchant is found' do
    get '/api/v1/merchant/find?name=harry'

    merchant_search = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq 404
    expect(merchant_search[:errors].first[:title]).to eq("No Record Found")
  end
end