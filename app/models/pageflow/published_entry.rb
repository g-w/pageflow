module Pageflow
  class PublishedEntry
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_reader :entry, :revision

    delegate(:account, :theming, :to_model, :to_key, :persisted?, :to => :entry)

    delegate(:chapters, :pages,
             :image_files, :video_files, :audio_files,
             :title, :summary, :credits, :manual_start,
             :to => :revision)

    def initialize(entry, revision = nil)
      @entry = entry
      @revision = revision || entry.published_revision
      @custom_revision = !!revision
    end

    def stylesheet_model
      custom_revision? ? revision : entry
    end

    def thumbnail
      pages.first.try(:thumbnail) || ImageFile.new.processed_attachment
    end

    def self.find(id)
      PublishedEntry.new(Entry.published.find(id))
    end

    def cache_key
      "#{self.class.model_name.cache_key}/#{entry.cache_key}-#{revision.cache_key}"
    end

    private

    def custom_revision?
      @custom_revision
    end
  end
end
