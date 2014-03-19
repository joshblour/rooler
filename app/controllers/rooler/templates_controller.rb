require_dependency "rooler/application_controller"

module Rooler
  class TemplatesController < ApplicationController
    before_action :set_template, only: [:test, :show, :edit, :update, :destroy]

    def test
      test_object = @template.test_object
      deliverable = Delivery.new(deliverable: test_object, template: @template) if test_object
      delivery = DeliveryMailer.send_mail(deliverable, params[:email]).deliver if deliverable
      if delivery
        redirect_to @template, notice: "Test email sent"
      else
        alert = test_object ? "Failed. Couldn't deliver email" : "Failed. Searched the rules associated with this template but couldn't find any objects to test with."
        redirect_to @template, alert: alert
      end
    end

    # GET /templates
    def index
      @templates = Template.all
    end

    # GET /templates/1
    def show
      test_object = @template.test_object
      if test_object
        @liquid_variables = {test_object.class.name.demodulize.downcase.to_s => test_object}
      else
        flash.now[:notice] = "Variables may be empty. Searched the rules associated with this template but couldn't find any objects to test with."
      end
    end

    # GET /templates/new
    def new
      @template = Template.new
    end

    # GET /templates/1/edit
    def edit
    end

    # POST /templates
    def create
      @template = Template.new(template_params)

      if @template.save
        redirect_to @template, notice: 'Template was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /templates/1
    def update
      if @template.update(template_params)
        redirect_to @template, notice: 'Template was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /templates/1
    def destroy
      @template.destroy
      redirect_to templates_url, notice: 'Template was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_template
        @template = Template.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def template_params
        params.require(:template).permit(:name, :to, :cc, :subject, :body)
      end
  end
end
