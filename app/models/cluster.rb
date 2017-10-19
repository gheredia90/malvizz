class Cluster < ApplicationRecord
  has_many :samples, foreign_key: :cluster_malheur_id, primary_key: :malheur_id
end
