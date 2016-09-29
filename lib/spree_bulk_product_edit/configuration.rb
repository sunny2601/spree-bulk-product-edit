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
    attr_accessor :admin_bulk_product_edits_per_page

    def initialize
      @surcharge_amount = 0
    end
  end
end
