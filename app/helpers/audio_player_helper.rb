module AudioPlayerHelper
  def audio_player(audio)
    # Fixed mimetypes determined by file extension
    mimetype = {
      'mp3' => 'audio/mpeg',
      'm4a' => 'audio/mp4',
      'ogg' => 'audio/ogg'
    }

    meta = JSON.parse(audio.meta)
    outputs = meta['output_settings']
    rv = "<audio preload=\"none\" controls>\n"
    outputs.each do |out|
      extension = out['extension']
      suffix = out.fetch('suffix', '')
      src = Settings.app_scheme + Settings.aws.cloudfront_domain + '/' \
        + audio.file_base + suffix + ".#{extension}"
      rv << "<source src=\"#{src}\" type=\"#{mimetype[extension]}\"/>\n"
    end
    rv << "Your browser does not support HTML5 audio.\n"
    rv << "</audio>\n"
    rv
  end
end
