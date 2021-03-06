require 'rails_helper'

describe AudiosController, type: :controller do

  let(:resource) { create(:audio_factory) }
  let(:attributes) { attributes_for(:audio_factory) }
  let(:invalid_attributes) { attributes_for(:invalid_audio_factory) }

  it_behaves_like 'admin-only route', :index, :show, :new, :create
  it_behaves_like 'an encoder', 'audio'

  context 'admin logged in' do
    login_admin

    it_behaves_like 'basic controller', :index, :show
    it_behaves_like 'media controller', :new, :create
  end
end
