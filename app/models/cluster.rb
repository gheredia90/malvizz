class Cluster < ApplicationRecord
  field :malheur_id, type: String
  field :name, type: String

  has_many :samples
end
