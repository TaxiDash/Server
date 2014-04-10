class StaticPagesController < ApplicationController

  def overview
    #TODO Set highest rated drivers
        # Week 
        # Month
    #TODO Set highest rated companies

    #TODO Set lowest rated drivers
    #TODO Set lowest rated companies
  end

  def import_export
    authorize! :import_export, Driver
    authorize! :import_export, Company
    authorize! :import_export, Rider
  end
end
