class MalheurController < ApplicationController
  def home
    data = { clusters: Cluster.all, samples: Sample.all.order('prototype desc') }

    respond_to do |format|
      format.html
      format.json { render json: data }
    end
  end

  def import
    parsed_malware_data = params[:raw_malware_data]
    Malheur.parse parsed_malware_data
  end
end
