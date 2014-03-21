FactoryGirl.define do
  factory :delivery, class: Rooler::Delivery do
    rule
    association :deliverable, factory: :rule
  end
end