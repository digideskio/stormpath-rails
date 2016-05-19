require 'spec_helper'

describe 'ForgotPassword', type: :request, vcr: true do
  describe "GET /forgot" do
    context 'application/json' do
      def json_forgot_get
        get '/forgot', {}, { 'HTTP_ACCEPT' => 'application/json' }
      end

      context "password reset enabled" do
        before do
          enable_forgot_password
          Rails.application.reload_routes!
        end

        it "return 404" do
          json_forgot_get
          expect(response.status).to eq(404)
        end
      end

      context "password reset disabled" do
        before do
          disable_forgot_password
          Rails.application.reload_routes!
        end

        it "return 404" do
          json_forgot_get
          expect(response.status).to eq(404)
        end
      end
    end

    context 'text/html' do
      context "password reset enabled" do
        before do
          enable_forgot_password
          Rails.application.reload_routes!
        end

        it "renders forgot password view" do
          get '/forgot'
          expect(response).to be_success
          expect(response).to render_template(:forgot)
        end
      end

      context "password reset disabled" do
        before do
          disable_forgot_password
          Rails.application.reload_routes!
        end

        it "renders 404" do
          get '/forgot'
          expect(response.status).to eq(404)
        end
      end
    end
  end

  describe "POST /forgot" do
    let(:user) { Stormpath::Rails::Client.application.accounts.create(user_attrs) }

    let(:user_attrs) do
      { email: 'example@test.com', given_name: 'Example', surname: 'Test', password: 'Pa$$W0RD', username: 'SirExample' }
    end

    before do
      user
      enable_forgot_password
      Rails.application.reload_routes!
    end

    after { user.delete }

    context 'application/json' do
      def json_forgot_post(attrs)
        post '/forgot', attrs, { 'HTTP_ACCEPT' => 'application/json' }
      end

      context "valid data" do
        it "return 200 OK" do
          json_forgot_post(email: user.email)
          expect(response).to be_success
        end
      end

      context "invalid data" do
        it "return 200 OK" do
          json_forgot_post(password: { email: "test@testable.com" })
          expect(response).to be_success
        end
      end
    end

    context 'text/html' do
      context "valid data" do
        it "redirects to login" do
          post '/forgot', password: { email: test_user.email }
          expect(response).to redirect_to('/login?status=forgot')
        end
      end

      context "invalid data" do
        it 'with wrong email redirects to login' do
          post '/forgot', password: { email: "test@testable.com" }
          expect(response).to redirect_to('/login?status=forgot')
        end

        it "with no email redirects to login" do
          post '/forgot', password: { email: "" }
          expect(response).to redirect_to('/login?status=forgot')
        end
      end
    end
  end






  # describe 'POST /login' do
  #   let(:user) { Stormpath::Rails::Client.application.accounts.create(user_attrs) }
  #
  #   let(:user_attrs) do
  #     { email: 'example@test.com', given_name: 'Example', surname: 'Test', password: 'Pa$$W0RD', username: 'SirExample' }
  #   end
  #
  #   before { user }
  #
  #   before do
  #     Rails.application.reload_routes!
  #   end
  #
  #   after  { user.delete }
  #
  #   describe 'HTTP_ACCEPT=text/html' do
  #     describe 'html is enabled' do
  #       it 'successfull login' do
  #         post '/login', login: user_attrs[:email], password: user_attrs[:password]
  #         expect(response).to redirect_to('/')
  #         expect(response.status).to eq(302)
  #       end
  #
  #       it 'failed login, wrong password' do
  #         post '/login', login: user_attrs[:email], password: 'WR00N6'
  #         expect(response.status).to eq(200)
  #         expect(response.body).to include('Invalid username or password')
  #       end
  #     end
  #
  #     describe 'html is disabled' do
  #       before do
  #         allow(Stormpath::Rails.config.produces).to receive(:accepts) { ['application/json'] }
  #         Rails.application.reload_routes!
  #       end
  #
  #       it 'returns 404' do
  #         post '/login', login: user_attrs[:email], password: user_attrs[:password]
  #         expect(response.status).to eq(404)
  #       end
  #     end
  #   end
  #
  #   describe 'HTTP_ACCEPT=application/json' do
  #     def json_login_post(attrs)
  #       post '/login', attrs, { 'HTTP_ACCEPT' => 'application/json' }
  #     end
  #
  #     describe 'json is enabled' do
  #       it 'successfull login should result with 200' do
  #         json_login_post(login: user_attrs[:email], password: user_attrs[:password])
  #         expect(response.status).to eq(200)
  #       end
  #
  #       it 'successfull login with username should result with 200' do
  #         json_login_post(login: user_attrs[:username], password: user_attrs[:password])
  #         expect(response.status).to eq(200)
  #       end
  #
  #       it 'successfull login should have content-type application/json' do
  #         json_login_post(login: user_attrs[:email], password: user_attrs[:password])
  #         expect(response.content_type.to_s).to eq('application/json')
  #       end
  #
  #       it 'successfull login should match schema' do
  #         json_login_post(login: user_attrs[:email], password: user_attrs[:password])
  #         expect(response).to match_response_schema(:login_response, strict: true)
  #       end
  #
  #       it 'failed login, wrong password should result with 400' do
  #         json_login_post(login: user_attrs[:email], password: 'WR00N6')
  #         expect(response.status).to eq(400)
  #       end
  #
  #       it 'failed login, wrong password should result with only a message and a status in the response body' do
  #         json_login_post(login: user_attrs[:email], password: 'WR00N6')
  #
  #         response_body = JSON.parse(response.body)
  #         expect(response_body['status']).to eq(400)
  #         expect(response_body['message']).to eq('Invalid username or password.')
  #       end
  #     end
  #
  #     describe 'json is disabled' do
  #       before do
  #         allow(Stormpath::Rails.config.produces).to receive(:accepts) { ['application/html'] }
  #         Rails.application.reload_routes!
  #       end
  #
  #       it 'returns 404' do
  #         json_login_post(login: user_attrs[:email], password: user_attrs[:password])
  #         expect(response.status).to eq(404)
  #       end
  #     end
  #   end
  #
  #   describe 'HTTP_ACCEPT=nil' do
  #     def login_post_with_nil_http_accept(attrs)
  #       post '/login', attrs, { 'HTTP_ACCEPT' => nil }
  #     end
  #
  #     describe 'json is enabled' do
  #       it 'successfull login should result with 200' do
  #         login_post_with_nil_http_accept(login: user_attrs[:email], password: user_attrs[:password])
  #         expect(response.status).to eq(200)
  #       end
  #
  #       it 'successfull login with username should result with 200' do
  #         login_post_with_nil_http_accept(login: user_attrs[:username], password: user_attrs[:password])
  #         expect(response.status).to eq(200)
  #       end
  #
  #       it 'successfull login should have content-type application/json' do
  #         login_post_with_nil_http_accept(login: user_attrs[:email], password: user_attrs[:password])
  #         expect(response.content_type.to_s).to eq('application/json')
  #       end
  #
  #       it 'successfull login should match schema' do
  #         login_post_with_nil_http_accept(login: user_attrs[:email], password: user_attrs[:password])
  #         expect(response).to match_response_schema(:login_response, strict: true)
  #       end
  #
  #       it 'failed login, wrong password should result with 400' do
  #         login_post_with_nil_http_accept(login: user_attrs[:email], password: 'WR00N6')
  #         expect(response.status).to eq(400)
  #       end
  #
  #       it 'failed login, wrong password should result with only a message and a status in the response body' do
  #         login_post_with_nil_http_accept(login: user_attrs[:email], password: 'WR00N6')
  #
  #         response_body = JSON.parse(response.body)
  #         expect(response_body['status']).to eq(400)
  #         expect(response_body['message']).to eq('Invalid username or password.')
  #       end
  #     end
  #
  #     describe 'json is disabled' do
  #       before do
  #         allow(Stormpath::Rails.config.produces).to receive(:accepts) { ['text/html'] }
  #         Rails.application.reload_routes!
  #       end
  #
  #       it 'returns 404' do
  #         login_post_with_nil_http_accept(login: user_attrs[:email], password: user_attrs[:password])
  #         expect(response.status).to eq(302)
  #       end
  #     end
  #   end
  #
  #   describe 'login disabled' do
  #     before do
  #       allow(Stormpath::Rails.config.login).to receive(:enabled) { false }
  #       Rails.application.reload_routes!
  #     end
  #
  #     it 'returns 404' do
  #       post '/login', login: user_attrs[:email], password: user_attrs[:password]
  #       expect(response.status).to eq(404)
  #     end
  #   end
  #
  #   describe 'login next_uri changed' do
  #     before { Stormpath::Rails.config.login.next_uri = '/abc' }
  #     after  { Stormpath::Rails.config.login.reset_attributes }
  #
  #     it 'should redirect to next_uri' do
  #       post '/login', login: user_attrs[:email], password: user_attrs[:password]
  #       expect(response).to redirect_to('/abc')
  #       expect(response.status).to eq(302)
  #     end
  #   end
  #
  #   describe 'login sent with ?next=other_url' do
  #     it 'should redirect to next_uri' do
  #       post '/login?next=other', login: user_attrs[:email], password: user_attrs[:password]
  #       expect(response).to redirect_to('/other')
  #       expect(response.status).to eq(302)
  #     end
  #   end
  # end
end