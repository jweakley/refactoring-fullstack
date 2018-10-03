# frozen_string_literal: true
require 'date'

# Class that generates some simple reports from invoices.
class InvoiceReport
  def initialize(invoices, start_date, end_date)
    @invoices = invoices
    @start_date = start_date
    @end_date = end_date
  end

  def total_outstanding_for_date_range
    valid_invoices = @invoices.select do |invoice|
      invoice.invoiced_at >= @start_date && invoice.invoiced_at <= @end_date &&
        invoice.billed && !invoice.payment_received
    end

    valid_invoices
      .map { |invoice| invoice.total_hours * invoice.rate_per_hour }
      .inject(0) { |sum, total_time_in_minutes| total_time_in_minutes + sum }
  end

  def total_billed_for_date_range
    valid_invoices = @invoices.select do |invoice|
      invoice.invoiced_at >= @start_date && invoice.invoiced_at <= @end_date &&
        invoice.billed
    end

    valid_invoices
      .map { |invoice| invoice.total_hours * invoice.rate_per_hour }
      .inject(0) { |sum, total_time_in_minutes| total_time_in_minutes + sum }
  end

  def total_received_for_date_range
    valid_invoices = @invoices.select do |invoice|
      invoice.invoiced_at >= @start_date && invoice.invoiced_at <= @end_date &&
        invoice.billed && invoice.payment_received
    end

    valid_invoices
      .map { |invoice| invoice.total_hours * invoice.rate_per_hour }
      .inject(0) { |sum, total_time_in_minutes| total_time_in_minutes + sum }
  end
end

# A single invoice
class Invoice
  attr_accessor :invoiced_at, :billed, :payment_received
  attr_accessor :total_hours, :rate_per_hour
end
