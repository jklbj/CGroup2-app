# frozen_string_literal: true

require_relative '../spec_helper'
require 'webmock/minitest'

describe 'Test Service Objects' do
  before do
    @credentials = { name: 'Kevin Yang', password: 'mypa$$w0rd' }
    @mal_credentials = { name: 'Kevin Yang', password: 'wrongpassword' }
    @api_account = { attributes:
                       { name: 'Kevin Yang', email: 'KevinYang@nthu.edu.tw' } }
  end

  after do
    WebMock.reset!
  end

  describe 'Find authenticated account' do
    it 'HAPPY: should find an authenticated account' do
      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: @credentials.to_json)
             .to_return(body: @api_account.to_json,
                        headers: { 'content-type' => 'application/json' })

      account = CGroup2::AuthenticateAccount.new(app.config).call(@credentials)
      _(account).wont_be_nil
      _(account['name']).must_equal @api_account[:attributes][:name]
      _(account['email']).must_equal @api_account[:attributes][:email]
    end

    it 'BAD: should not find a false authenticated account' do
      WebMock.stub_request(:post, "#{API_URL}/auth/authenticate")
             .with(body: @mal_credentials.to_json)
             .to_return(status: 403)
      proc {
        CGroup2::AuthenticateAccount.new(app.config).call(@mal_credentials)
      }.must_raise CGroup2::AuthenticateAccount::UnauthorizedError
    end
  end
end
