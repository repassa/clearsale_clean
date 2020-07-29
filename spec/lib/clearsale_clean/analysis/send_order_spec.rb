# frozen_string_literal: true

RSpec.describe ClearsaleClean::Analysis::SendOrder, vcr: { cassette_name: 'send_order' } do
  describe '#send_order' do
    let(:connector) { ClearsaleClean::Connector.instance }
    let(:xml_order) { double('xml') }
    let(:order) do
      {
        'user': {
          id: 8888,
          email: 'petergriffin@abc.com',
          cpf: '248.783.463-37',
          full_name: 'Peter Löwenbräu Griffin',
          birthdate: 40.years.ago,
          phone: '11 8001 1002',
          gender: 'm',
          last_sign_in_ip: '127.0.0.1'
        },
        'payment': {
          payment_type: '1',
          card_holder: 'Petter L Griffin',
          card_number: '1234432111112222',
          card_expiration: '05/2012',
          card_security_code: '123',
          acquirer: 'visa',
          amount: 50.00
        },
        'order': {
          id: 1234,
          finger_print: 'aaaa1111',
          total_shipping: 18.00,
          total_items: 20.00,
          total_order: 38.00,
          installments: 3,
          shipping_type: 'correio',
          status: 'new',
          created_at: Time.current,
          paid_at: 2.seconds.ago,
          billing_address: {
            street_name: 'Bla St',
            number: '123',
            complement: '',
            neighborhood: 'Rhode Island',
            city: 'Mayland',
            state: 'Maryland',
            country: 'Brasil',
            postal_code: '00100-011'
          },
          shipping_address: {
            street_name: 'Bla St',
            number: '123',
            complement: '',
            neighborhood: 'Rhode Island',
            city: 'Mayland',
            state: 'Maryland',
            country: 'Brasil',
            postal_code: '00100-011'
          },
          order_items: [
            {
              product: {
                id: 5555,
                name: 'Pogobol',
                category: { id: 7777, name: 'Disney' }
              },
              price: 5.00,
              quantity: 2
            },
            {
              product: {
                id: 5555,
                name: 'Pogobol',
                category: { id: 7777, name: 'Disney' }
              },
              price: 5.00,
              quantity: 2
            }
          ]
        }
      }
    end

    context 'when mount response' do
      it 'send order for mount response' do
        allow(ClearsaleClean::Mount::Order).to receive_message_chain('new.to_xml')
          .with(order)
          .with(no_args)
          .and_return(xml_order)

        expect(ClearsaleClean::Mount::OrderResponse).to receive(:build_from_send_order)
          .with(connector.do_request('SendOrders', { xml: xml_order }))

        described_class.new(order).send_order
      end
    end

    context 'when the mount order' do
      it 'send order to mount tags' do
        expect(ClearsaleClean::Mount::Order).to receive_message_chain('new.to_xml')
          .with(order)
          .with(no_args)
          .and_return(xml_order)

        described_class.new(order).send_order
      end
    end
  end
end
