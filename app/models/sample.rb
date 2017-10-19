class Sample < ApplicationRecord
  belongs_to :cluster, optional: true, foreign_key: :cluster_malheur_id,
                       primary_key: :malheur_id
end
