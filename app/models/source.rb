class Source < ActiveRecord::Base
  belongs_to :source_set, touch: true
  has_many :guides, through: :source_set
  has_many :attachments, dependent: :destroy

  has_many :videos, through: :attachments,
                    source: :asset,
                    source_type: 'Video'

  has_many :audios, through: :attachments,
                    source: :asset,
                    source_type: 'Audio'

  has_many :documents, through: :attachments,
                       source: :asset,
                       source_type: 'Document'

  has_many :images, through: :attachments,
                    source: :asset,
                    source_type: 'Image',
                    after_add: :touch_self,
                    before_remove: :touch_self

  has_many :large_images, -> { where size: 'large' },
                          through: :attachments,
                          source: :asset,
                          source_type: 'Image',
                          after_add: :touch_self,
                          before_remove: :touch_self

  has_many :small_images, -> { where size: 'small' },
                          through: :attachments,
                          source: :asset,
                          source_type: 'Image',
                          after_add: :touch_self,
                          before_remove: :touch_self

  has_many :thumbnails, -> { where size: 'thumbnail' },
                        through: :attachments,
                        source: :asset,
                        source_type: 'Image',
                        after_add: :touch_self,
                        before_remove: :touch_self

  validates :aggregation, presence: true, 
                          format: { with: /\A[a-zA-Z0-9]+\z/,
                                    message: 'can only be letters and numbers' }

  default_scope { order('created_at ASC') }

  ##
  # Gets all assets associated with source through attachments table.
  # @return Array<ActiveRecord::Base>
  def assets
    attachments.map(&:asset).reject{ |a| a.nil? }
  end

  ##
  # Gets the first audio, video, document, or large image associated with the
  # source.
  # @return <ActiveRecord::Base>
  def main_asset
    assets.delete_if do |a|
      true if a.class.name == 'Image' && a.size != 'large'
    end.first
  end

  def thumbnail
    thumbnails.first
  end

  def small_image
    small_images.first
  end

  def display_name
    name.present? ? name : aggregation
  end

  ##
  # Get all other sources associated with this source's source_set.
  # The source that would appear after the current source in a default database
  # query is first in the return array.
  #
  # @example:
  #   <Source id: 3>.related_sources =>
  #      [<Source id: 4>, <Source id: 1>, <Source id: 2>]
  #
  # @return [Array<Source>]
  def related_sources
    source_set.sources.includes(:thumbnails).split { |s| s.id == id }.reverse.flatten
  end

  ##
  # @param Vocabulary
  # @return [ActiveRecord::Association<Tag>]
  def self.with_image(image)
    joins(:attachments).where(attachments: { asset_type: 'Image' })
                       .where(attachments: { asset_id: image.id })
  end

  ##
  # Update the cache key of all sources associated with a given image.
  # Update the cache key of all source sets associated with the sources.
  # @param Image
  def self.touch_sources_with_image(image)
    # Note that update_all does not trigger ActiveRecord callbacks.
    with_image(image).update_all(updated_at: Time.now)
    SourceSet.touch_sets_with_sources(with_image(image))
  end

  private

  ##
  # Update cache keys of self and all associated source sets.
  # @param ActiveRecord
  def touch_self(record)
    return if self.new_record? # cannot touch unsaved record
    self.touch
  end
end
