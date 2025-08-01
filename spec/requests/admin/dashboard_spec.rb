require 'rails_helper'

RSpec.describe "Admin::Dashboards", type: :request do
  let(:admin_user) { FactoryBot.create(:admin_user) }

  describe "GET /admin" do
    it "returns http success when logged in" do
      sign_in admin_user, scope: :admin_user
      get admin_root_path
      expect(response).to have_http_status(:success)
    end

    it "redirects to login when not logged in" do
      get admin_root_path
      expect(response).to redirect_to(new_admin_user_session_path)
    end
  end
end
