class MalheurController < ApplicationController
  def home
    @clusters = Cluster.all.to_json
    @samples  = Sample.all.to_json
  end

  def import
    parsed_malware_data = params[:raw_malware_data]
    Malheur.parse parsed_malware_data
  end
end
