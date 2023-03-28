class ItemSerializer
  include JSONAPI::Serializer
  attributes :name
  attributes :description
  attributes :unit_price
  attributes :merchant_id
end
