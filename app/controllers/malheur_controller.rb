class MalheurController < ApplicationController
  def home; end

  def import
    parsed_malware_data = params[:raw_malware_data]
    Malheur.parse parsed_malware_data
  end
end
