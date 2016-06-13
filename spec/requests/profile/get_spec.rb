require 'spec_helper'

describe 'Me GET', type: :request, vcr: true do
  def response_body
    JSON.parse(response.body)
  end

  let(:account) { Stormpath::Rails::Client.application.accounts.create(account_attrs) }

  let(:account_attrs) do
    {
      email: 'example@test.com',
      given_name: 'Example',
      surname: 'Test',
      password: 'Pa$$W0RD',
      username: 'SirExample'
    }
  end

  before do
    post '/login', login: account.email, password: account_attrs[:password]
  end

  after { account.delete }

  context 'application/json' do
    def json_me_get
      get '/me', {}, 'HTTP_ACCEPT' => 'application/json'
    end

    context 'me enabled' do
      before do
        enable_profile
        Rails.application.reload_routes!
      end

      it 'return 200' do
        json_me_get
        expect(response.status).to eq(200)
      end

      it 'matches schema' do
        json_me_get
        expect(response).to match_response_schema(:login_response, strict: true)
      end

      describe 'totally expanded' do
        let(:expansion) do
          OpenStruct.new(
            api_keys: false,
            applications: true,
            custom_data: true,
            directory: true,
            group_memberships: true,
            groups: true,
            provider_data: true,
            tenant: true
          )
        end

        before do
          allow(web_config.me).to receive(:expand).and_return(expansion)
        end

        it 'matches schema' do
          json_me_get
          expect(response).to match_response_schema(:profile_response, strict: true)
        end
      end
    end

    context 'me disabled' do
      before do
        disable_profile
        Rails.application.reload_routes!
      end

      it 'return 404' do
        json_me_get
        expect(response.status).to eq(404)
      end
    end
  end

  context 'text/html' do
    context 'me enabled' do
      before do
        enable_profile
        Rails.application.reload_routes!
      end

      it 'renders json view' do
        get '/me'
        expect(response).to be_success
      end
    end

    context 'me disabled' do
      before do
        disable_profile
        Rails.application.reload_routes!
      end

      it 'renders 404' do
        get '/me'
        expect(response.status).to eq(404)
      end
    end
  end
end
