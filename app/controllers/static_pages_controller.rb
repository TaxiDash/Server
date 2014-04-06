class StaticPagesController < ApplicationController
    def import_export
        authorize! :import_export, Driver
        authorize! :import_export, Company
        authorize! :import_export, Rider
    end
end
