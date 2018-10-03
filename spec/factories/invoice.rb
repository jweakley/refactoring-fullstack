FactoryBot.define do
  factory :invoice do
    rate_per_hour { 200.0 }
    total_hours { 0.5 }

    trait :billed do
      billed { true }
    end

    trait :unbilled do
      billed { false }
    end

    trait :paid do
      payment_received { true }
    end

    trait :unpaid do
      payment_received { false }
    end

    factory :billed_and_paid_invoice, traits: [:billed, :paid]
    factory :unbilled_and_unpaid_invoice, traits: [:unbilled, :unpaid]
    factory :billed_and_unpaid_invoice, traits: [:billed, :unpaid]
  end
end
