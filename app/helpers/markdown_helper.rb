require 'redcarpet/render_strip'

module MarkdownHelper
  ##
  # @param String text A markdown formatted String
  # @return String An HTML representation of the markdown string given in 'text'
  # @raise TypeError if @param is not a String
  def markdown(text)
    options = { autolink: true, footnotes: true }
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, options).render(text)
                       .html_safe
  end

  ##
  # @param String text A markdown formatted String
  # @return String An HTML representation of the markdown string given in 'text'
  # without enclosing <p> tags.
  # @raise TypeError if @param is not a String
  def inline_markdown(text)
    strip_p_tags(markdown(text))
  end

  ##
  # @return String a plain text representation of the markdown string given in
  # 'text'.  Removes trailing newline.
  def plaintext_from_md(text)
    Redcarpet::Markdown.new(Redcarpet::Render::StripDown).render(text).chomp
  end

  private

  ##
  # This strips enclosing <p> tags from an HTML formatted String.
  #
  # @param String html An HTML formatted String
  # @return String An HTML fomratted String
  #
  # This is intended for HTML-formatted Strings that were rendered from markdown
  # with the Redcarpet gem.  Redcarpet automatically encloses all markdown-
  # formatted Strings in <p> tags, which need to be stripped for inline
  # elements.
  # As a sanity check, if a String has internal <p> tags, the enclosing <p> tags
  # are not stripped.
  def strip_p_tags(html)
    match = Regexp.new('^<p>(.*)<\/p>$').match(html)
    return html unless match.present?
    return html if match[1].include?('<p>') || match[1].include?('</p>')
    match[1].html_safe
  end
end
