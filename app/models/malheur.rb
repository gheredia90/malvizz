class Malheur
  def self.parse(malware_data)
    self.clean_previous_clusters_and_samples

    @parsed_data = { clusters: [], samples: [] }

    DATA.each_line do |line|
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
    sample[:report] == sample[:prototype] && sample[:distance].to_i.zero?
  end

  def self.clean_previous_clusters_and_samples
    Cluster.destroy_all
    Sample.destroy_all
  end

  DATA =
    " # MALHEUR (0.6.0) - Automatic Analysis of Malware Behavior
      # Copyright (c) 2009-2015 Konrad Rieck (konrad@mlsec.org)
      # University of Goettingen, Berlin Institute of Technology
      # ---
      # Clusters for /home/fernando/.cuckoo/storage/malheur/reports
      # Number of cluster: 14
      # Precision of clusters: 100.0 %
      # Recall of clusters: 30.3 %
      # F-measure of clusters: 46.5 %
      # ---
      # <report> <cluster> <prototype> <distance>
      31.txt C000-0002 31.txt 0
      53.txt C000-0002 19.txt 0.605811
      71.txt C000-0029 71.txt 0
      32.txt C000-0008 46.txt 0.266373
      75.txt rejected 75.txt 0.000345267
      39.txt C000-0032 37.txt 0.459506
      65.txt C000-0019 65.txt 0
      37.txt C000-0032 37.txt 0.000345267
      55.txt C000-0003 55.txt 0.000345267
      85.txt C000-0027 77.txt 0.517638
      74.txt rejected 74.txt 0
      44.txt rejected 44.txt 0.000345267
      35.txt C000-0006 36.txt 0.195244
      82.txt rejected 82.txt 0.000302109
      26.txt C000-0005 26.txt 0
      73.txt rejected 73.txt 0.000319343
      84.txt C000-0032 84.txt 0
      56.txt C000-0005 26.txt 0.371942
      25.txt C000-0006 36.txt 0.197438
      66.txt rejected 66.txt 0
      30.txt C000-0003 55.txt 0.338204
      28.txt C000-0015 28.txt 0
      16.txt C000-0011 16.txt 0.000302109
      19.txt C000-0002 19.txt 0.000345267
      70.txt rejected 70.txt 0.000345267
      87.txt C000-0002 87.txt 0.000345267
      69.txt C000-0029 69.txt 0.000345267
      27.txt C000-0011 27.txt 0
      15.txt rejected 15.txt 0
      79.txt C000-0027 77.txt 0.517638
      81.txt rejected 81.txt 0
      34.txt C000-0010 20.txt 0.3602
      24.txt rejected 24.txt 0.000345267
      21.txt C000-0003 21.txt 0
      14.txt C000-0001 14.txt 0.000345267
      86.txt C000-0027 77.txt 0.517638
      51.txt C000-0015 51.txt 0
      62.txt rejected 62.txt 0
      22.txt C000-0005 26.txt 0.208249
      48.txt rejected 48.txt 0.000345267
      78.txt rejected 78.txt 0.000165753
      46.txt C000-0008 46.txt 0.000149505
      47.txt C000-0006 36.txt 0.197731
      20.txt C000-0010 20.txt 0
      17.txt C000-0006 36.txt 0.195244
      45.txt C000-0006 36.txt 0.206262
      29.txt C000-0003 29.txt 0.000345267
      67.txt C000-0019 67.txt 0
      59.txt C000-0006 36.txt 0.206108
      77.txt C000-0027 77.txt 0.000345267
      83.txt rejected 83.txt 0
      64.txt rejected 64.txt 0
      57.txt C000-0030 57.txt 0.000345267
      50.txt C000-0003 50.txt 0
      23.txt C000-0030 57.txt 0.000345267
      61.txt C000-0011 61.txt 0
      76.txt rejected 76.txt 0.000445389
      63.txt C000-0001 63.txt 0.000345267
      54.txt C000-0010 54.txt 0
      36.txt C000-0006 36.txt 0
      68.txt rejected 68.txt 0.000355893
      60.txt C000-0005 26.txt 0.0191237
      58.txt rejected 58.txt 0.000345267
      49.txt rejected 49.txt 0
      80.txt rejected 80.txt 0.000376246
    "
end
