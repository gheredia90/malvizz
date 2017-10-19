class Sample < ApplicationRecord
  field :cluster_malheur_id, type: String
  field :malheur_id, type: String
  field :prototype, type: Boolean
  field :distance, type: Float

  belongs_to :cluster, optional: true

  def initialize
    self.cluster_malheur_id = cluster.malheur_id
  end
end
