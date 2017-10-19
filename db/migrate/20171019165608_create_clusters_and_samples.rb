class CreateClustersAndSamples < ActiveRecord::Migration[5.1]
  def change
    create_table :clusters do |t|
      t.string :malheur_id
      t.string :name

      t.timestamps
    end

    create_table :samples do |t|
      t.string  :cluster_malheur_id
      t.boolean :prototype
      t.float   :distance
      t.string  :report

      t.timestamps
    end
  end
end
