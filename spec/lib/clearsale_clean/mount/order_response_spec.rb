# frozen_string_literal: true

RSpec.describe ClearsaleClean::Mount::OrderResponse do
  let(:response_send) { described_class.build_from_send_order(package_send) }
  let(:response_send_no_order) { described_class.build_from_send_order(package_send_without_order) }
  let(:response_update) { described_class.build_from_update(package_update) }
  let(:response_update_no_order) { described_class.build_from_update(package_update_without_order) }
  let(:package_send) do
    {
      package_status: {
        orders: {
          order:
          {
            id: '1',
            score: '5.0',
            status: 'APA'
          }
        }
      }
    }
  end

  let(:package_update) do
    {
      clear_sale: {
        orders: {
          order:
          {
            id: '1',
            score: '5.0',
            status: 'APA'
          }
        }
      }
    }
  end
  let(:package_send_without_order) do
    {
      package_status: {
        transaction_id: nil,
        status_code: '05',
        message: 'Pedido 687016 já existe e não está como reanalise.'
      }
    }
  end

  let(:package_update_without_order) do
    {
      clear_sale: {
        orders: {
          order: nil
        }
      }
    }
  end

  describe '.build_from_send_order' do
    context 'when when APA' do
      it 'returns automatic_approval' do
        expect(response_send).to include(
          order_id: 1,
          score: 5.0,
          status: :automatic_approval
        )
      end
    end

    context 'when when APM' do
      it 'returns manual_approval' do
        package_send[:package_status][:orders][:order][:status] = 'APM'

        expect(response_send).to include(
          order_id: 1,
          score: 5.0,
          status: :manual_approval
        )
      end
    end

    context 'when when RPM' do
      it 'returns rejected_without_suspicion' do
        package_send[:package_status][:orders][:order][:status] = 'RPM'

        expect(response_send).to include(
          order_id: 1,
          score: 5.0,
          status: :rejected_without_suspicion
        )
      end
    end

    context 'when when AMA' do
      it 'returns manual_analysis' do
        package_send[:package_status][:orders][:order][:status] = 'AMA'

        expect(response_send).to include(
          order_id: 1,
          score: 5.0,
          status: :manual_analysis
        )
      end
    end

    context 'when when NVO' do
      it 'returns waiting' do
        package_send[:package_status][:orders][:order][:status] = 'NVO'

        expect(response_send).to include(
          order_id: 1,
          score: 5.0,
          status: :waiting
        )
      end
    end

    context 'when when SUS' do
      it 'returns manual_rejection' do
        package_send[:package_status][:orders][:order][:status] = 'SUS'

        expect(response_send).to include(
          order_id: 1,
          score: 5.0,
          status: :manual_rejection
        )
      end
    end

    context 'when when CAN' do
      it 'returns cancelled' do
        package_send[:package_status][:orders][:order][:status] = 'CAN'

        expect(response_send).to include(
          order_id: 1,
          score: 5.0,
          status: :cancelled
        )
      end
    end

    context 'when when FRD' do
      it 'returns fraud' do
        package_send[:package_status][:orders][:order][:status] = 'FRD'

        expect(response_send).to include(
          order_id: 1,
          score: 5.0,
          status: :fraud
        )
      end
    end

    context 'when when RPA' do
      it 'returns automatic_rejection' do
        package_send[:package_status][:orders][:order][:status] = 'RPA'

        expect(response_send).to include(
          order_id: 1,
          score: 5.0,
          status: :automatic_rejection
        )
      end
    end

    context 'when when RPP' do
      it 'returns policy_rejection' do
        package_send[:package_status][:orders][:order][:status] = 'RPP'

        expect(response_send).to include(
          order_id: 1,
          score: 5.0,
          status: :policy_rejection
        )
      end
    end

    context 'when when APP' do
      it 'returns policy_approval' do
        package_send[:package_status][:orders][:order][:status] = 'APP'

        expect(response_send).to include(
          order_id: 1,
          score: 5.0,
          status: :policy_approval
        )
      end
    end
  end

  describe '.build_from_update' do
    context 'when APA' do
      it 'returns automatic_approval' do
        expect(response_send).to include(
          order_id: 1,
          score: 5.0,
          status: :automatic_approval
        )
      end
    end

    context 'when APM' do
      it 'returns manual_approval' do
        package_update[:clear_sale][:orders][:order][:status] = 'APM'

        expect(response_update).to include(
          order_id: 1,
          score: 5.0,
          status: :manual_approval
        )
      end
    end

    context 'when RPM' do
      it 'returns rejected_without_suspicion' do
        package_update[:clear_sale][:orders][:order][:status] = 'RPM'

        expect(response_update).to include(
          order_id: 1,
          score: 5.0,
          status: :rejected_without_suspicion
        )
      end
    end

    context 'when AMA' do
      it 'returns manual_analysis' do
        package_update[:clear_sale][:orders][:order][:status] = 'AMA'

        expect(response_update).to include(
          order_id: 1,
          score: 5.0,
          status: :manual_analysis
        )
      end
    end

    context 'when NVO' do
      it 'returns waiting' do
        package_update[:clear_sale][:orders][:order][:status] = 'NVO'

        expect(response_update).to include(
          order_id: 1,
          score: 5.0,
          status: :waiting
        )
      end
    end

    context 'when SUS' do
      it 'returns manual_rejection' do
        package_update[:clear_sale][:orders][:order][:status] = 'SUS'

        expect(response_update).to include(
          order_id: 1,
          score: 5.0,
          status: :manual_rejection
        )
      end
    end

    context 'when CAN' do
      it 'returns cancelled' do
        package_update[:clear_sale][:orders][:order][:status] = 'CAN'

        expect(response_update).to include(
          order_id: 1,
          score: 5.0,
          status: :cancelled
        )
      end
    end

    context 'when FRD' do
      it 'returns fraud' do
        package_update[:clear_sale][:orders][:order][:status] = 'FRD'

        expect(response_update).to include(
          order_id: 1,
          score: 5.0,
          status: :fraud
        )
      end
    end

    context 'when RPA' do
      it 'returns automatic_rejection' do
        package_update[:clear_sale][:orders][:order][:status] = 'RPA'

        expect(response_update).to include(
          order_id: 1,
          score: 5.0,
          status: :automatic_rejection
        )
      end
    end

    context 'when RPP' do
      it 'returns policy_rejection' do
        package_update[:clear_sale][:orders][:order][:status] = 'RPP'

        expect(response_update).to include(
          order_id: 1,
          score: 5.0,
          status: :policy_rejection
        )
      end
    end

    context 'when APP' do
      it 'returns policy_approval' do
        package_update[:clear_sale][:orders][:order][:status] = 'APP'

        expect(response_update).to include(
          order_id: 1,
          score: 5.0,
          status: :policy_approval
        )
      end
    end
  end

  context 'when response blank in send' do
    it 'returns order_not_accepted', :aggregate_failures do
      expect(response_send_no_order.dig(:status)).to eq :order_not_accepted
      expect(response_send_no_order).to include(
        status: :order_not_accepted,
        message: 'Pedido 687016 já existe e não está como reanalise.'
      )
    end
  end

  context 'when response blank in response' do
    it 'returns order_not_accepted', :aggregate_failures do
      expect(response_update_no_order.dig(:status)).to eq :order_not_accepted
      expect(response_update_no_order).to include(
        status: :order_not_accepted,
        message: nil
      )
    end
  end
end
