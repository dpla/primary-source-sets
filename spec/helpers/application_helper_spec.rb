require 'rails_helper'

describe ApplicationHelper, type: :helper do
   
  describe '#markdown' do

    it 'renders HTML from a markdown String' do
      text = '**Moomin!**'
      expect(helper.markdown(text)).to eq("<p><strong>Moomin!</strong></p>\n")
    end

    it 'raises a TypeError if input is not a String' do
      invalid_input = 123
      expect{ helper.markdown(invalid_input) }.to raise_error(TypeError)
     end
  end

  describe '#inline_markdown' do

    it 'strips enclosing <p> tags' do
      text = '**Moomin!**'
      expect(helper.inline_markdown(text)).to eq("<strong>Moomin!</strong>")
    end

    it 'leaves enclosing <p> tags if there are internal <p> tags' do
      text = '<p>Moomin!</p><p>Snorkmaiden</p>'
      expect(helper.inline_markdown(text))
        .to eq("<p>Moomin!</p><p>Snorkmaiden</p>\n")
    end
  end

  describe '#frontend_path' do
    it 'constructs a URI with correct /s' do
      allow(Settings).to receive_message_chain(:frontend, :url)
        .and_return 'http://example.com/'
      expect(helper.frontend_path('/path')).to eq 'http://example.com/path'
    end
  end

  describe '#exhibitions_path' do
    it 'constructs a URI with correct /s' do
      allow(Settings).to receive_message_chain(:exhibitions, :url)
        .and_return 'http://example.com'
      expect(helper.exhibitions_path('path')).to eq 'http://example.com/path'
    end
  end

  describe '#wordpress_path' do
    it 'constructs a URI with correct /s' do
      allow(Settings).to receive_message_chain(:wordpress, :url)
        .and_return 'http://example.com/'
      expect(helper.wordpress_path('path/')).to eq 'http://example.com/path/'
    end
  end

  describe '#branding_stylesheets' do
    it 'returns dpla-colors stylesheet' do
      expect(helper.branding_stylesheets).to match(/dpla-colors.css/)
    end

    it 'returns dpla-fonts stylesheet' do
      expect(helper.branding_stylesheets).to match(/dpla-fonts.css/)
    end
  end
end
