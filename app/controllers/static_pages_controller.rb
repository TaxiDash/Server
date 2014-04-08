class StaticPagesController < ApplicationController

  def overview
    #TODO Set highest rated drivers
  end

  def import_export
    authorize! :import_export, Driver
    authorize! :import_export, Company
    authorize! :import_export, Rider
  end
end
