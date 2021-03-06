require 'rails_helper'

describe VideosController, type: :controller do

  let(:resource) { create(:video_factory) }
  let(:attributes) { attributes_for(:video_factory) }
  let(:invalid_attributes) { attributes_for(:invalid_video_factory) }

  it_behaves_like 'admin-only route', :index, :show, :new, :create
  it_behaves_like 'an encoder', 'video'

  context 'admin logged in' do
    login_admin

    it_behaves_like 'basic controller', :show
    it_behaves_like 'media controller', :new, :create
  end
end
