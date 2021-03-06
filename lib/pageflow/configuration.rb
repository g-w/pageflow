module Pageflow
  # Options to be defined in the pageflow initializer of the main app.
  class Configuration
    # Default options for paperclip attachments which are supposed to
    # use filesystem storage.
    attr_accessor :paperclip_filesystem_default_options

    # Default options for paperclip attachments which are supposed to use
    # s3 storage.
    attr_accessor :paperclip_s3_default_options

    # String to interpolate into paths of files generated by paperclip
    # preprocessors. This allows to refresh cdn caches after
    # reprocessing attachments.
    attr_accessor :paperclip_attachments_version

    # Path to the location in the filesystem where attachments shall
    # be stored. The value of this option is available via the
    # pageflow_filesystem_root paperclip interpolation.
    attr_accessor :paperclip_filesystem_root

    # Refer to the pageflow initializer template for a list of
    # supported options.
    attr_accessor :zencoder_options

    # A constraint used by the pageflow engine to restrict access to
    # the editor related HTTP end points. This can be used to ensure
    # the editor is only accessable via a certain host when different
    # CNAMES are used to access the public end points of pageflow.
    attr_accessor :editor_route_constraint

    # The email address to use as from header in invitation mails to
    # new users
    attr_accessor :mailer_sender

    # Subscribe to hooks in order to be notified of events. Any object
    # with a call method can be a subscriber
    #
    # Example:
    #
    #     config.hooks.subscribe(:submit_file, -> { do_something })
    #
    attr_reader :hooks

    # Limit the use of certain resources. Any object implementing the
    # interface of Pageflow::Quota can be registered.
    #
    # Example:
    #
    #     config.quotas.register(:users, UserQuota)
    #
    attr_accessor :quotas

    # Additional themes can be registered to use custom css.
    #
    # Example:
    #
    #     config.themes.register(:custom)
    #
    # @return [Themes]
    attr_reader :themes

    # Either a lambda or an object with a `match?` method, to restrict
    # access to the editor routes defined by Pageflow.
    #
    # This can be used if published entries shall be available under
    # different CNAMES but the admin and the editor shall only be
    # accessible via one official url.
    attr_accessor :editor_routing_constraint

    def initialize
      @paperclip_filesystem_default_options = {}
      @paperclip_s3_default_options = {}

      @zencoder_options = {}

      @mailer_sender = 'pageflow@example.com'

      @hooks = Hooks.new
      @quotas = Quotas.new
      @themes = Themes.new
    end

    # Make a page type available for use in the system.
    def register_page_type(page_type)
      page_types << page_type

      @page_types_by_name ||= {}
      @page_types_by_name[page_type.name] = page_type
    end

    def lookup_page_type(name)
      @page_types_by_name.fetch(name)
    end

    def page_types
      @page_types ||= []
    end

    def page_type_names
      page_types.map(&:name)
    end
  end
end
