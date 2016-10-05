using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Address < Model
      resource :addresses
      model :address

      attr_accessor :id_customer, :firstname, :lastname, :address1, :address2, :city, :phone, :phone_mobile, :id_country, :id_state, :postcode, :address_alias
      attr_writer   :id

      def initialize args = {}
        @id            = args[:id]
        @id_customer   = args.fetch(:id_customer)
        @firstname     = args.fetch(:firstname)
        @lastname      = args.fetch(:lastname)
        @address1      = args.fetch(:address1)
        @address2      = args[:address2]
        @id_state      = args[:id_state]
        @city          = args.fetch(:city)
        @phone         = args[:phone]
        @phone_mobile  = args.fetch(:phone_mobile, '')
        @id_country    = args.fetch(:id_country)
        @postcode      = args[:postcode]
        @address_alias = args.fetch(:address_alias)
      end

      def hash
        address = {
          id_customer:  id_customer,
          firstname:    firstname,
          lastname:     lastname,
          address1:     address1,
          address2:     address2,
          id_state:     id_state,
          city:         city,
          phone:        phone,
          phone_mobile: phone_mobile,
          id_country:   id_country,
          postcode:     postcode,
          alias:        address_alias
        }
      end
    end
  end
end