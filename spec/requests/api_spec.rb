require 'spec_helper'

RSpec.describe 'SMS API docs', type: :request do
  let(:app) { Rack::Builder.new.run Rails.application }

  context 'external-accounts' do
    it 'renders successfully' do
      get '/api/external-accounts'

      expect(last_response.status).to be(200)
    end
  end
end
