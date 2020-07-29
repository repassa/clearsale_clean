# frozen_string_literal: true

module ClearsaleClean
  # Module for Analisys
  module Analysis
    # Send order for Analysis
    class SendOrder
      attr_reader :order

      def initialize(order)
        @order = order
      end

      def send_order
        Mount::OrderResponse.build_from_send_order(
          Connector.instance.do_request('SendOrders', { xml: xml_order })
        )
      end

      private

      def xml_order
        Mount::Order.new(order).to_xml
      end
    end
  end
end
