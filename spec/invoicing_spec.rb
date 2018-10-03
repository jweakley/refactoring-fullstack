require_relative '../lib/invoicing'
require 'spec_helper'

describe InvoiceReport do
  subject { InvoiceReport.new(invoices, start_date, end_date) }
  let(:start_date) { Date.new(2018,10,1) }
  let(:end_date) { Date.new(2018,10,31) }

  let(:valid_invoice) do
    build(:billed_and_paid_invoice, invoiced_at: Date.new(2018,10,3))
  end

  let(:unbilled_invoice) do
    build(:unbilled_and_unpaid_invoice, invoiced_at: Date.new(2018,10,3))
  end

  let(:unpaided_invoice) do
    build(:billed_and_unpaid_invoice, invoiced_at: Date.new(2018,10,3))
  end

  let(:old_invoice) do
    build(:billed_and_paid_invoice, invoiced_at: Date.new(2018,9,3))
  end

  describe '#total_outstanding_for_date_range' do
    context 'single invoice' do
      let(:invoices) { [unpaided_invoice] }
      it { expect(subject.total_outstanding_for_date_range).to eq (100) }
    end

    context 'mixed invoices' do
      let(:invoices) do
        [valid_invoice, unbilled_invoice, unpaided_invoice, old_invoice]
      end
      it { expect(subject.total_outstanding_for_date_range).to eq (100) }
    end
  end

  describe '#total_billed_for_date_range' do
    context 'single invoice' do
      let(:invoices) { [valid_invoice] }
      it { expect(subject.total_billed_for_date_range).to eq (100) }
    end

    context 'mixed invoices' do
      let(:invoices) do
        [unpaided_invoice, unbilled_invoice, old_invoice]
      end
      it { expect(subject.total_billed_for_date_range).to eq (100) }
    end
  end

  describe '#total_received_for_date_range' do
    context 'single invoice' do
      let(:invoices) { [valid_invoice] }
      it { expect(subject.total_received_for_date_range).to eq (100) }
    end

    context 'mixed invoices' do
      let(:invoices) do
        [valid_invoice, unbilled_invoice, unpaided_invoice, old_invoice]
      end
      it { expect(subject.total_received_for_date_range).to eq (100) }
    end
  end
end
