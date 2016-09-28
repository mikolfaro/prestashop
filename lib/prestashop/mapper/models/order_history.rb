using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class OrderHistory < Model
      resource :order_histories
      model :order_history

      attr_accessor     :id_order, :id_order_state
      attr_writer       :id

      def initialize args = {}
        @id               = args[:id]
        @id_order         = args.fetch(:id_order)
        @id_order_state   = args.fetch(:id_order_state, 3)
      end

      def hash
        order_history = {
          id_order:       id_order,
          id_order_state: id_order_state,
        }
      end
    end
  end
end