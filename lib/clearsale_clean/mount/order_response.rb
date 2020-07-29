# frozen_string_literal: true

module ClearsaleClean
  module Mount
    # Response for Order
    class OrderResponse
      STATUS_MAP = {
        # Pedido foi aprovado automaticamente segundo
        # parametros definidos na regra de aprovacao automatica
        APA: :automatic_approval,
        # Pedido aprovado manualmente por tomada de decisao de um analista.
        APM: :manual_approval,
        # Pedido Reprovado sem Suspeita por falta de contato
        # com o cliente dentro do periodo acordado e/ou politicas
        # restritivas de CPF (Irregular, SUS ou Cancelados).
        RPM: :rejected_without_suspicion,
        # Pedido esta em fila para analise
        AMA: :manual_analysis,
        # Pedido importado e nao classificado Score pela analisadora
        # (processo que roda o Score de cada pedido).
        NVO: :waiting,
        # Pedido Suspenso por suspeita de fraude baseado no
        # contato com o 'cliente' ou ainda na base ClearSale.
        SUS: :manual_rejection,
        # Cancelado por solicitacao do cliente ou duplicidade do pedido.
        CAN: :cancelled,
        # Pedido imputado como Fraude Confirmada por contato com a
        # administradora de cartao e/ou contato com titular do cartao
        # ou CPF do cadastro que desconhecem a compra.
        FRD: :fraud,
        # Pedido Reprovado Automaticamente por algum tipo
        # de Regra de Negocio que necessite aplica-la
        # (Obs: nao usual e nao recomendado).
        RPA: :automatic_rejection,
        # Pedido reprovado automaticamente por politica
        # estabelecida pelo cliente ou ClearSale.
        RPP: :policy_rejection,
        # Pedido aprovado automaticamente por politica
        # estabelecida pelo cliente ou ClearSale.
        APP: :policy_approval
      }.freeze

      attr_reader :package

      def self.build_from_send_order(package)
        new(package).build_from_send_order
      end

      def self.build_from_update(package)
        new(package).build_from_update
      end

      def build_from_send_order
        response(package.fetch(:package_status, {}))
      end

      def build_from_update
        response(package.fetch(:clear_sale, {}))
      end

      def initialize(package)
        @package = package
      end

      private

      def response(hash)
        response = hash.fetch(:orders, {}).fetch(:order, {})

        if response.blank?
          {
            status: :order_not_accepted,
            message: hash[:message]
          }
        else
          {
            order_id: response[:id].remove(/[a-zA-Z]*/).to_i,
            score: response[:score].to_f,
            status: STATUS_MAP[response[:status].to_sym]
          }
        end
      end
    end
  end
end
