# frozen_string_literal: true

require 'builder'

module ClearsaleClean
  module Mount
    class Order
      STATUS_TYPE_MAP = {
        # Novo (sera analisado pelo ClearSale)
        new: 0,
        # Aprovado (ira ao ClearSale ja aprovado e nao sera analisado)
        approved: 9,
        # Cancelado pelo cliente (ira ao ClearSale ja cancelado e nao sera analisado)
        canceled: 41,
        # Reprovado (ira ao ClearSale ja reprovado e nao sera analisado)
        rejected: 45
      }.freeze
      SHIPPING_TYPE_MAP = {
        other: 0,
        correio: 11,
        motoboy: 12
      }.freeze
      PAYMENT_TYPE_MAP = {
        creditcard: 1,
        bankslip: 2,
        cupon: 12,
        other: 14
      }.freeze
      CARD_TYPE_MAP = {
        diners: 1,
        mastercard: 2,
        visa: 3,
        other: 4,
        amex: 5,
        hipercard: 6,
        aura: 7
      }.freeze

      attr_reader :order

      def initialize(order)
        @order = order
      end

      def to_xml
        builder = Builder::XmlMarkup.new
        builder.tag!('ClearSale') do |b|
          b.tag!('Orders') do |b2|
            b2.tag!('Order') do |b3|
              build_order(
                b3,
                order.fetch(:order),
                order.fetch(:payment),
                order.fetch(:user)
              )
            end
          end
        end.to_s
      end

      private

      def build_order(builder, order, payment, user)
        builder.tag!('ID', order[:id])
        builder.tag!('FingerPrint') do |b|
          b.tag!('SessionID', order[:finger_print])
        end
        builder.tag!('Date', order[:created_at])
        builder.tag!('Email', user[:email])
        builder.tag!('ShippingPrice', order[:total_shipping])
        builder.tag!('TotalItems', order[:total_items])
        builder.tag!('TotalOrder', order[:total_order])
        builder.tag!('QtyInstallments', order[:installments])
        builder.tag!('DeliveryTimeCD', order[:delivery_time]) if order[:delivery_time].present?
        builder.tag!('IP', user[:last_sign_in_ip])
        builder.tag!('ShippingType', SHIPPING_TYPE_MAP.fetch(order[:shipping_type].to_s.to_sym, 0))
        builder.tag!('Status', STATUS_TYPE_MAP.fetch(order[:status].to_s.to_sym, 0))
        builder.tag!('BillingData') do |b|
          build_user_order(b, user, order[:billing_address])
        end
        builder.tag!('ShippingData') do |b|
          build_user_order(b, user, order[:shipping_address])
        end
        builder.tag!('Payments') do |b|
          build_payment_order(b, order, payment, user)
        end
        builder.tag!('Items') do |b|
          order[:order_items].each do |order_item|
            build_item(b, order_item)
          end
        end
      end

      def build_user_order(builder, user, billing_address)
        builder.tag!('ID', user[:id])
        builder.tag!('Type', 1)
        builder.tag!('LegalDocument1', user[:cpf].gsub(/[\.\-]*/, '').strip)
        builder.tag!('Name', user[:full_name])
        builder.tag!('BirthDate', user[:birthdate]) if user[:birthdate].present?
        builder.tag!('Email', user[:email])
        builder.tag!('Gender', user[:gender].downcase) if user[:gender].present?
        build_address(builder, billing_address)

        builder.tag!('Phones') do |b|
          build_phone(b, user)
        end
      end

      def build_address(builder, address)
        builder.tag!('Address') do |_b|
          builder.tag!('Street', address[:street_name])
          builder.tag!('Number', address[:number])
          builder.tag!('Comp', address[:complement])
          builder.tag!('County', address[:neighborhood])
          builder.tag!('City', address[:city])
          builder.tag!('State', address[:state])
          builder.tag!('Country', address[:country])
          builder.tag!('ZipCode', address[:postal_code])
        end
      end

      def build_phone(builder, user)
        if user[:phone].present?
          stripped_phone =
            begin
              user[:phone].scan(/\d+/).join
            rescue StandardError
              user[:phone].gsub(/\D+/, '')
            end

          builder.tag!('Phone') do |b|
            b.tag!('Type', 0)
            b.tag!('DDD', stripped_phone[0..1])
            b.tag!('Number', stripped_phone[2..-1])
          end
        else
          builder.tag!('Phone') do |b|
            b.tag!('Type', 0)
            b.tag!('DDD', 0)
            b.tag!('Number', 0)
          end
        end
      end

      def build_payment_order(builder, order, payment, user)
        builder.tag!('Payment') do |b|
          paid_at = order[:paid_at] || Time.current
          payment_type = PAYMENT_TYPE_MAP.fetch(payment[:payment_type].to_s.to_sym, 1)

          b.tag!('Date', paid_at)
          b.tag!('Amount', payment[:amount])
          b.tag!('PaymentTypeID', payment_type) # Failover is 'creditcard'

          if payment_type == 1
            b.tag!('QtyInstallments', order[:installments])
            b.tag!('CardBin', payment[:card_number][0..5])
            b.tag!('CardEndNumber', payment[:card_number][6..10])
            b.tag!('CardType', CARD_TYPE_MAP.fetch(payment[:acquirer].to_s.to_sym, 4)) # Failover is 'outros'
            b.tag!('CardExpirationDate', payment[:card_expiration])
            b.tag!('Name', payment[:card_holder])
          end

          b.tag!('LegalDocument', user[:cpf].gsub(/[\.\-]*/, '').strip)
          build_address(b, order[:billing_address])

          b.tag!('Currency', '986')
        end
      end

      def build_item(builder, order_item)
        builder.tag!('Item') do |b|
          b.tag!('ID', order_item[:product][:id])
          b.tag!('Name', order_item[:product][:name])
          b.tag!('ItemValue', order_item[:price])
          b.tag!('Qty', order_item[:quantity])

          if order_item[:product][:category].try(:[], :id).present?
            b.tag!('CategoryID', order_item[:product][:category][:id])
          end
          if order_item[:product][:category].try(:[], :name).present?
            b.tag!('CategoryName', order_item[:product][:category][:name])
          end
        end
      end
    end
  end
end
