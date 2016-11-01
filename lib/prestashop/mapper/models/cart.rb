using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Cart < Model
      resource :carts
      model    :cart

      attr_accessor     :id_customer, :id_address_delivery, :id_address_invoice, 
                        :id_currency, :id_lang, :id_carrier, :cart_rows
      attr_writer       :id

      def initialize args = {}
        @id                   = args[:id]
        @id_customer          = args.fetch(:id_customer)
        @id_address_delivery  = args.fetch(:id_address_delivery)
        @id_address_invoice   = args.fetch(:id_address_invoice)
        @id_currency          = args.fetch(:id_currency, 1)
        @id_lang              = args.fetch(:id_lang, 1)
        @id_carrier           = args.fetch(:id_carrier)
        @cart_rows            = args[:cart_rows]
      end

      def hash
        cart = {
          id_customer:         id_customer,
          id_address_delivery: id_address_delivery,
          id_address_invoice:  id_address_invoice,
          id_currency:         id_currency,
          id_lang:             id_lang,
          id_carrier:          id_carrier,
          associations: {}
        }
        if cart_rows_hash
          cart[:associations][:cart_rows] = {}
          cart[:associations][:cart_rows][:cart_row] = cart_rows_hash
        end
        cart
      end

      # Generates hash of single cart row
      def cart_row_hash id_product, id_product_attribute, quantity
        { 
          id_product: id_product, 
          id_product_attribute: id_product_attribute, 
          quantity: quantity 
        } if id_product && id_product_attribute && quantity
      end

      # Generates hash of cart rows
      def cart_rows_hash
        cart_rows.map { |row| 
          cart_row_hash(
            row[:id_product],
            row[:id_product_attribute],
            row[:quantity]
          )
        } if cart_rows
      end

      # Find or create cart from hash
      def find_or_create
        cart = self.class.find_by 'filter[id]' => id
        cart ? cart : create[:id]
      end

      class << self
        def customer_last_non_ordered(id_customer)
          cart = self.where('filter[id_customer]' => id_customer, 'sort' => '[id_DESC]', 'limit' => 1, display: 'full') unless id_customer.present?
          non_ordered cart.first unless cart.blank?
        end

        def find_non_ordered(id_cart)
          cart = self.find_by('filter[id]' => id_cart, display: 'full') unless id_cart.present?
          non_ordered cart
        end

        private 

        def non_ordered(cart)
          order = Order.where('filter[id_cart]' => cart[:id]) unless cart.blank?
          cart if order.blank?
        end
      end
    end
  end
end