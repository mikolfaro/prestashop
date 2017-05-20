using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class OrderCarrier < Model
      resource :order_carriers
      model :order_carrier

      attr_accessor     :id_order, :id_carrier, :shipping_cost_tax_excl, :shipping_cost_tax_incl
      attr_writer       :id

      def initialize args = {}
        @id         = args[:id]
        @id_order   = args.fetch(:id_order)
        @id_carrier = args.fetch(:id_carrier)
        @shipping_cost_tax_excl = args.fetch(:shipping_cost_tax_excl, 0.0)
        @shipping_cost_tax_incl = args.fetch(:shipping_cost_tax_incl, 0.0)
      end

      def hash
        order_carrier = {
          id_order:   id_order,
          id_carrier: id_carrier,
          shipping_cost_tax_excl: shipping_cost_tax_excl,
          shipping_cost_tax_incl: shipping_cost_tax_incl
        }
      end
    end
  end
end