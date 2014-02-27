module Rooler
  class DeliveryMailer < ActionMailer::Base
    helper ApplicationHelper
    include ApplicationHelper
    
    default from: "from@example.com"
    
    def send_mail(delivery)
       template = delivery.template
       deliverable = delivery.deliverable
       
       @liquid_variables = {deliverable.class.name.demodulize.downcase => deliverable}
       @body = template.body
       
       mail to: liquidize(template.to, @liquid_variables),
            cc: liquidize(template.cc, @liquid_variables), 
            subject: liquidize(template.subject, @liquid_variables)
    end
  end
end
