class ApplicationRecord < ActiveRecord::Base
  include Filterable

  self.abstract_class = true
end
