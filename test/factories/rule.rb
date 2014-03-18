FactoryGirl.define do
  factory :rule, class: Rooler::Rule do
    sequence(:name) {|n| "rule-#{n}"}
    template
    klass_name 'Foo'
    klass_finder_method 'active_record_finder'
  end
end