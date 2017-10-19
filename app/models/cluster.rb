class Cluster < ApplicationRecord
  has_many :samples, foreign_key: :cluster_malheur_id, primary_key: :malheur_id

  validates :malheur_id, uniqueness: true

end
