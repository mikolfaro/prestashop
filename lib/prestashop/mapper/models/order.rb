using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class Order < Model
      resource :orders
      model :order

      attr_accessor   :id_customer, :id_address_delivery, :id_address_invoice, :id_cart, 
                      :id_currency, :id_lang, :id_carrier, :id_shop, :id_shop_group, 
                      :current_state, :valid, :payment, :payment_module, :conversion_rate
      attr_accessor   :order_rows
      attr_writer     :id

      def initialize args = {}
        @id                   = args[:id]
        @id_customer          = args.fetch(:id_customer)
        @id_address_delivery  = args[:id_address_delivery]
        @id_address_invoice   = args[:id_address_invoice]
        @id_cart              = args[:id_cart]
        @id_currency          = args[:id_currency]
        @id_lang              = args.fetch(:id_lang, 1)
        @id_carrier           = args[:id_carrier]
        @id_shop              = args.fetch(:id_shop, 1)
        @id_shop_group        = args.fetch(:id_shop_group, 1)
        @current_state        = args.fetch(:current_state)
        @valid                = args.fetch(:valid, 0)
        @payment              = args.fetch(:payment, 'No payment')
        @payment_module       = args.fetch(:payment_module, 'No payment module')
        @conversion_rate      = args.fetch(:conversion_rate, 1.0)
        @order_rows           = args[:order_rows]
      end

      # ID of order, or find ID by +reference+ and +id_order+
      def id
        @id ||= self.class.find_by 'filter[reference]' => reference
      end
      alias :find? :id

      def hash
        order = {
          id_customer:  id_customer,
          id_address_delivery:  id_address_delivery,
          id_address_invoice:   id_address_invoice,
          id_cart:  id_cart,
          id_currency:  id_currency,
          id_lang:  id_lang,
          id_carrier:   id_carrier,
          id_shop:  id_shop,
          id_shop_group:  id_shop_group,
          current_state:  current_state,
          valid:  valid,
          payment:  payment,
          'module':   payment_module,
          conversion_rate:  conversion_rate,
          associations:   {}
        }
        if order_rows_hash
          order[:associations][:order_rows] = {}
          order[:associations][:order_rows][:order_row] = order_rows_hash
        end
        order
      end

      # Generates hash of single order row
      def order_row_hash id_product, id_product_attribute, quantity
        { 
          id_product: id_product, 
          id_product_attribute: id_product_attribute, 
          quantity: quantity 
        } if id_product && id_product_attribute && quantity
      end

      # Generates hash of order rows
      def order_rows_hash
        order_rows.map { |row| 
          order_row_hash(
            row[:id_product],
            row[:id_product_attribute],
            row[:quantity],
          )
        } if order_rows
      end      

    end
  end
end