# frozen_string_literal: true

RSpec.describe ClearsaleClean::Mount::Order do
  describe '#to_xml' do
    subject(:mount_order) { described_class.new(order) }

    let(:xml_order) do
      '<ClearSale><Orders><Order><ID>1234</ID><FingerPrint><SessionID>aaaa1111</SessionID></FingerPrint><Date>2007-11-19T08:37:48</Date><Email>petergriffin@abc.com</Email><ShippingPrice>18.0</ShippingPrice><TotalItems>20.0</TotalItems><TotalOrder>38.0</TotalOrder><QtyInstallments>3</QtyInstallments><DeliveryTimeCD>2</DeliveryTimeCD><IP>127.0.0.1</IP><ShippingType>11</ShippingType><Status>0</Status><BillingData><ID>8888</ID><Type>1</Type><LegalDocument1>24878346337</LegalDocument1><Name>Peter Löwenbräu Griffin</Name><BirthDate>2007-11-19T08:37:48</BirthDate><Email>petergriffin@abc.com</Email><Gender>m</Gender><Address><Street>Bla St</Street><Number>123</Number><Comp></Comp><County>Rhode Island</County><City>Mayland</City><State>Maryland</State><Country>Brasil</Country><ZipCode>00100-011</ZipCode></Address><Phones><Phone><Type>0</Type><DDD>11</DDD><Number>80011002</Number></Phone></Phones></BillingData><ShippingData><ID>8888</ID><Type>1</Type><LegalDocument1>24878346337</LegalDocument1><Name>Peter Löwenbräu Griffin</Name><BirthDate>2007-11-19T08:37:48</BirthDate><Email>petergriffin@abc.com</Email><Gender>m</Gender><Address><Street>Bla St</Street><Number>123</Number><Comp></Comp><County>Rhode Island</County><City>Mayland</City><State>Maryland</State><Country>Brasil</Country><ZipCode>00100-011</ZipCode></Address><Phones><Phone><Type>0</Type><DDD>11</DDD><Number>80011002</Number></Phone></Phones></ShippingData><Payments><Payment><Date>2020-05-20T08:37:46</Date><Amount>50.0</Amount><PaymentTypeID>1</PaymentTypeID><QtyInstallments>3</QtyInstallments><CardBin>123443</CardBin><CardEndNumber>21111</CardEndNumber><CardType>3</CardType><CardExpirationDate>05/2012</CardExpirationDate><Name>Petter L Griffin</Name><LegalDocument>24878346337</LegalDocument><Address><Street>Bla St</Street><Number>123</Number><Comp></Comp><County>Rhode Island</County><City>Mayland</City><State>Maryland</State><Country>Brasil</Country><ZipCode>00100-011</ZipCode></Address><Currency>986</Currency></Payment></Payments><Items><Item><ID>5555</ID><Name>Pogobol</Name><ItemValue>5.0</ItemValue><Qty>2</Qty><CategoryID>7777</CategoryID><CategoryName>Disney</CategoryName></Item><Item><ID>5555</ID><Name>Pogobol</Name><ItemValue>5.0</ItemValue><Qty>2</Qty><CategoryID>7777</CategoryID><CategoryName>Disney</CategoryName></Item></Items></Order></Orders></ClearSale>'
    end
    let(:xml_order_bankslip) do
      '<ClearSale><Orders><Order><ID>1234</ID><FingerPrint><SessionID>aaaa1111</SessionID></FingerPrint><Date>2007-11-19T08:37:48</Date><Email>petergriffin@abc.com</Email><ShippingPrice>18.0</ShippingPrice><TotalItems>20.0</TotalItems><TotalOrder>38.0</TotalOrder><QtyInstallments>3</QtyInstallments><DeliveryTimeCD>2</DeliveryTimeCD><IP>127.0.0.1</IP><ShippingType>11</ShippingType><Status>0</Status><BillingData><ID>8888</ID><Type>1</Type><LegalDocument1>24878346337</LegalDocument1><Name>Peter Löwenbräu Griffin</Name><BirthDate>2007-11-19T08:37:48</BirthDate><Email>petergriffin@abc.com</Email><Gender>m</Gender><Address><Street>Bla St</Street><Number>123</Number><Comp></Comp><County>Rhode Island</County><City>Mayland</City><State>Maryland</State><Country>Brasil</Country><ZipCode>00100-011</ZipCode></Address><Phones><Phone><Type>0</Type><DDD>11</DDD><Number>80011002</Number></Phone></Phones></BillingData><ShippingData><ID>8888</ID><Type>1</Type><LegalDocument1>24878346337</LegalDocument1><Name>Peter Löwenbräu Griffin</Name><BirthDate>2007-11-19T08:37:48</BirthDate><Email>petergriffin@abc.com</Email><Gender>m</Gender><Address><Street>Bla St</Street><Number>123</Number><Comp></Comp><County>Rhode Island</County><City>Mayland</City><State>Maryland</State><Country>Brasil</Country><ZipCode>00100-011</ZipCode></Address><Phones><Phone><Type>0</Type><DDD>11</DDD><Number>80011002</Number></Phone></Phones></ShippingData><Payments><Payment><Date>2020-05-20T08:37:46</Date><Amount>50.0</Amount><PaymentTypeID>2</PaymentTypeID><LegalDocument>24878346337</LegalDocument><Address><Street>Bla St</Street><Number>123</Number><Comp></Comp><County>Rhode Island</County><City>Mayland</City><State>Maryland</State><Country>Brasil</Country><ZipCode>00100-011</ZipCode></Address><Currency>986</Currency></Payment></Payments><Items><Item><ID>5555</ID><Name>Pogobol</Name><ItemValue>5.0</ItemValue><Qty>2</Qty><CategoryID>7777</CategoryID><CategoryName>Disney</CategoryName></Item><Item><ID>5555</ID><Name>Pogobol</Name><ItemValue>5.0</ItemValue><Qty>2</Qty><CategoryID>7777</CategoryID><CategoryName>Disney</CategoryName></Item></Items></Order></Orders></ClearSale>'
    end
    let(:order) do
      {
        'user': {
          id: 8888,
          email: 'petergriffin@abc.com',
          cpf: '248.783.463-37',
          full_name: 'Peter Löwenbräu Griffin',
          birthdate: '2007-11-19T08:37:48',
          phone: '11 8001 1002',
          gender: 'm',
          last_sign_in_ip: '127.0.0.1'
        },
        'payment': {
          payment_type: 'creditcard',
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
          created_at: '2007-11-19T08:37:48',
          paid_at: '2020-05-20T08:37:46',
          delivery_time: 2,
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

    context 'when sending order to the xml converter is for creditcard' do
      it 'order converted to xml' do
        expect(mount_order.to_xml).to eq xml_order
      end
    end

    context 'when sending order to the xml converter is for any other means of payment' do
      it 'order converted to xml' do
        order[:payment][:payment_type] = 'bankslip'

        expect(mount_order.to_xml).to eq xml_order_bankslip
      end
    end
  end
end
