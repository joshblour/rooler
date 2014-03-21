FactoryGirl.define do
  factory :template, class: Rooler::Template do
    sequence(:name) {|n| "template-#{n}"}
    to "test@email.com"
    sequence(:subject) {|n| "subject-#{n}"}
    sequence(:body) {|n| "body-#{n}"}
  end
end