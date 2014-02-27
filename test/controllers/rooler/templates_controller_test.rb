# require 'test_helper'
# 
# module Rooler
#   class TemplatesControllerTest < ActionController::TestCase
#     
#     setup do
#       @template = create(:template)
#     end
# 
#     test "should get index" do
#       get :index, use_route: :engine_controllers
#       assert_response :success
#       assert_not_nil assigns(:templates)
#     end
# 
#     test "should get new" do
#       get :new, use_route: :engine_controllers
#       assert_response :success
#     end
# 
#     test "should create template" do
#       assert_difference('Template.count') do
#         post :create, template: { body: @template.body, cc: @template.cc, name: @template.name, subject: @template.subject, to: @template.to }, use_route: :engine_controllers
#       end
# 
#       assert_redirected_to template_path(assigns(:template))
#     end
# 
#     test "should show template" do
#       get :show, id: @template, use_route: :engine_controllers
#       assert_response :success
#     end
# 
#     test "should get edit" do
#       get :edit, id: @template, use_route: :engine_controllers
#       assert_response :success
#     end
# 
#     test "should update template" do
#       patch :update, id: @template, template: { body: @template.body, cc: @template.cc, name: @template.name, subject: @template.subject, to: @template.to }, use_route: :engine_controllers
#       assert_redirected_to template_path(assigns(:template))
#     end
# 
#     test "should destroy template" do
#       assert_difference('Template.count', -1) do
#         delete :destroy, id: @template, use_route: :engine_controllers
#       end
# 
#       assert_redirected_to templates_path
#     end
#   end
# end
