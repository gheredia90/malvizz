class Malheur
  def self.parse(malware_data)
    self.clean_previous_clusters_and_samples

    @parsed_data = { clusters: [], samples: [] }

    malware_data.each_line do |line|
      line = line.strip
      next if line.starts_with? '#'
      splitted_line = line.split
      next unless splitted_line.size == 4
      report    = splitted_line[0]
      cluster   = splitted_line[1]
      prototype = splitted_line[2]
      distance  = splitted_line[3]

      unless cluster == 'rejected' && !@parsed_data[:clusters].include?(cluster)
        @parsed_data[:clusters] << cluster
      end

      sample = {
        cluster_malheur_id: cluster,
        report: report,
        prototype: prototype,
        distance: distance
      }
      sample[:prototype] = self.prototype?(sample)
      @parsed_data[:samples] << sample
    end

    self.create_clusters unless @parsed_data[:clusters].empty?
    self.create_samples unless @parsed_data[:samples].empty?
  end

  def self.create_clusters
    @parsed_data[:clusters].each do |cluster|
      Cluster.create malheur_id: cluster
    end
  end

  def self.create_samples
    @parsed_data[:samples].each do |sample|
      Sample.create sample
    end
  end

  def self.prototype?(sample)
    return true if sample[:cluster_malheur_id] == 'rejected'
    sample[:report] == sample[:prototype] && sample[:distance].to_f.zero?
  end

  def self.clean_previous_clusters_and_samples
    Cluster.destroy_all
    Sample.destroy_all
  end
end
