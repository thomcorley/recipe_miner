module Errors
  class MissingDirectory < StandardError
    def initialize(class_name)
      super("[#{class_name}] Website directory must be provided")
    end
  end

  class SitemapNotFound < StandardError
    def initialize(class_name, website_url)
      super("[#{class_name}] Cannot find sitemap for #{website_url}")
    end
  end
end
