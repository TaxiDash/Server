#   Copyright 2014 Vanderbilt University
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  
  # GET /documents
  # GET /documents.json
  def index
    if params[:search]
  		@documents = Document.search(params[:search]).order("driver_id asc")
  	else
	    @documents = params[:sort] == nil ? Document.all : Document.order(sort_column + " " + sort_direction)
	end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
  end

  def view
    @document = Document.find(params[:id])
    send_file(@document.doc.path, :type =>
          @document.doc_content_type, :disposition => 'inline')
  end

  # Download CSV
  def download
      @documents = Document.all
      puts "Sending data as csv..."
      send_data @documents.as_csv, :filename => "documents.csv"
  end

  # Import CSV
  def import
      Document.import(params[:file])
      redirect_to root_url, notice: "Documents imported."
  end

  # GET /drivers/docs/new/:driver_id
  def new
    @document = Document.new(:driver_id => params[:driver_id])
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document.driver, notice: 'Document was successfully created.' }
        format.json { render action: 'show', status: :created, location: @document }
      else
        format.html { render action: 'new' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document.driver, notice: 'Document was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @document }
      else
        format.html { render action: 'edit' }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end

  def search
  	@users = Document.search(params[:search])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:driver_id, :doc, :title, :description)
    end
    
    def sort_column
    	Document.column_names.include?(params[:sort]) ? params[:sort] : "driver_id"
    end

    def sort_direction
		%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
