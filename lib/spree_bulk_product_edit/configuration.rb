module SpreeBulkProductEdit
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :admin_edits_per_page
    attr_accessor :admin_edit_items_per_page

    def initialize
      @admin_edits_per_page = 30
      @admin_edit_items_per_page = 30
    end
  end
end
