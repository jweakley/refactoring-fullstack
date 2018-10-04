# frozen_string_literal: true

require 'date'

# Class that generates some simple reports from invoices.
class InvoiceReport
  def initialize(invoices, date_range)
    @invoices = invoices
    @date_range = date_range
  end

  def total_outstanding_for_date_range
    total_cost(outstanding_invoices_for_range)
  end

  def total_billed_for_date_range
    total_cost(billed_invoices_for_range)
  end

  def total_received_for_date_range
    total_cost(received_invoices_for_range)
  end

  private

  def total_cost(invoices)
    invoices.map(&:total).inject(0, :+)
  end

  def outstanding_invoices_for_range
    invoices_for_range.select(&:outstanding?)
  end

  def billed_invoices_for_range
    invoices_for_range.select(&:billed)
  end

  def received_invoices_for_range
    invoices_for_range.select(&:received_money?)
  end

  def invoices_for_range
    @invoices.select do |invoice|
      invoice.in_range?(@date_range)
    end
  end
end

# A class for date range
class DateRange
  attr_accessor :start_date, :end_date

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def includes?(date)
    (start_date..end_date).cover?(date)
  end
end

# A single invoice
class Invoice
  attr_accessor :invoiced_at, :billed, :payment_received
  attr_accessor :total_hours, :rate_per_hour

  def in_range?(date_range)
    date_range.includes?(invoiced_at)
  end

  def outstanding?
    billed && !payment_received
  end

  def received_money?
    billed && payment_received
  end

  def total
    total_hours * rate_per_hour
  end
end
