require_dependency "rooler/application_controller"

module Rooler
  class RulesController < ApplicationController
    include ActionView::Helpers::TextHelper
    
    before_action :set_rule, only: [:check, :show, :edit, :update, :destroy]
    
    # POST /rules/1
    def process
      results = @rule.process
      if results
        redirect_to rules_path, notice: "Success. #{pluralize(results.count, 'result')} processed"
      else
        redirect_to rules_path, alert: 'Failed to process rule'
      end
    end
    
    def find_matches
      results = @rule.find_by_klass
      if results
        redirect_to rules_path, notice: "Success. #{pluralize(results.count, 'match')} found"
      else
        redirect_to rules_path, alert: 'Failed to check rule'
      end
    end
    
    # GET /rules
    def index
      @rules = Rule.order(:created_at)
    end

    # GET /rules/1
    def show
    end

    # GET /rules/new
    def new
      @rule = Rule.new
    end

    # GET /rules/1/edit
    def edit
    end

    # POST /rules
    def create
      @rule = Rule.new(rule_params)

      if @rule.save
        redirect_to rules_url, notice: 'Rule was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /rules/1
    def update
      if @rule.update(rule_params)
        redirect_to rules_url, notice: 'Rule was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /rules/1
    def destroy
      @rule.destroy
      redirect_to rules_url, notice: 'Rule was successfully destroyed.'
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_rule
      @rule = Rule.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def rule_params
      params.require(:rule).permit(:name, :klass_name, :klass_finder_method, :template_id, :check_frequency, :method_params)
    end
  end
end
