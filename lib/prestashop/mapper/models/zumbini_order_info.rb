using Prestashop::Mapper::Refinement
module Prestashop
  module Mapper
    class ZumbiniOrderInfo < Model
      resource :zumbini_orders_info
      model :zumbini_order_info

      attr_accessor   :order_id, :zumbini_class_info, :zumbini_class_id
      attr_writer     :id

      def initialize args = {}
        @id                   = args[:id]
        @order_id             = args[:order_id]
        @zumbini_class_id     = args[:zumbini_class_id]
        @zumbini_class_info   = args.fetch(:zumbini_class_info, 'Class info')
      end

        def hash
        {
            order_id:  order_id,
            zumbini_class_info:  zumbini_class_info,
            zumbini_class_id: zumbini_class_id
        }
      end

    end
  end
end