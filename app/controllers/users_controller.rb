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


class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    helper_method :sort_column, :sort_direction
    load_and_authorize_resource
    helper_method :sort_column, :sort_direction

  # GET /users
  # GET /users.json
  def index
    if params[:search]
  		@users = User.search(params[:search]).order("last_name asc")
  	else
	    @users = params[:sort] == nil ? User.all : User.order(sort_column + " " + sort_direction)
	end
	@users = @users.page(params[:page])
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # Download csv
  def download
      @users = User.all
      puts "Sending data as csv..."
      send_data @users.as_csv, :filename => "users.csv"
  end

  # Import CSV
  def import
      User.import(params[:file])
      redirect_to root_url, notice: "Users imported."
  end

  def role?(role)
      #roles should be stored in CamelCase
      return !!self.roles.find_by_name(role.to_s.camelize)
  end

  def accessible_roles
      @accessible_roles = Role.accessible_by(current_ability,:read)
  end

  # Make the current user object available to views
  def get_user
      @current_user = current_user
  end
  #rescue ActiveRecord::RecordNotFound
  #respond_to_not_found(:json, :xml, :html)
  #end
  # GET /users/new
  def new
      @user = User.new
      #redirect_to '/users/sign_up'
  end

  # GET /users/modify/1
  def edit
      @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
      @user = User.new(user_params)

      respond_to do |format|
          if @user.save
              format.html { redirect_to @user, notice: 'User was successfully created.' }
              format.json { render action: 'show', status: :created, location: @user }
          else
              format.html { render action: 'new' }
              format.json { render json: @user.errors, status: :unprocessable_entity }
          end
      end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
      puts "Updating USER -------------------------------------------------------------------------"
      if params[:user][:password].blank?
          [:password,:password_confirmation,:current_password].collect{|p| params[:user].delete(p) }
      else
          @user.errors[:base] << "The password you entered is incorrect" unless @user.valid_password?(params[:user][:current_password])
      end
      respond_to do |format|
          if @user.update(user_params)
              format.html { redirect_to @user, notice: 'User was successfully updated.' }
              format.json { render action: 'show', status: :ok, location: @user }
          else
              format.html { render action: 'edit' }
              format.json { render json: @user.errors, status: :unprocessable_entity }
          end
      end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
      @user.destroy
      respond_to do |format|
          format.html { redirect_to users_url }
          format.json { head :no_content }
      end
  end

  def search
  	@users = User.search(params[:search])
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
      puts "Finding user with id " << params[:id]
      @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
      puts "Getting params -------------------------------------------------------------------------"
      params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :password_confirmation, :admin)
  end
  
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : ""
  end

  def sort_direction
	%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
