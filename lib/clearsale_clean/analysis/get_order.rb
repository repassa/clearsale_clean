# frozen_string_literal: true

module ClearsaleClean
  module Analysis
    # Get order from ID
    class GetOrder
      attr_reader :order_id

      def initialize(order_id)
        @order_id = order_id
      end

      def order_status
        Mount::OrderResponse.build_from_update(
          Connector.instance.do_request('GetOrderStatus', { orderID: order_id })
        )
      end
    end
  end
end
