module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(params)
      results = self.where(nil)
      filtering_params = self.filtering_params(params)

      filtering_params.each do |key, value|
        results = results.public_send(key, value) if value.present?
      end
      results
    end

    def paged(params, page_default = 1, per_page_default = nil)
      page = params[:page] || page_default
      per_page = params[:per_page] || per_page_default || Rails.configuration.default_page_size

      return {page: page, count: self.count, results: self.paginate(page: page, per_page: per_page)}
    end

    def filtered_page(params, page_default = 1, per_page_default = nil)
      self.filter(params).paged(params, page_default, per_page_default)
    end
  end
end