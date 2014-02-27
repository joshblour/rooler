FactoryGirl.define do
  factory :rule, class: Rooler::Rule do
    sequence(:name) {|n| "rule-#{n}"}
    template
    klass_name 'Rooler::Rule'
    klass_finder_method 'to_a'
    instance_checker_method 'present?'
  end
end