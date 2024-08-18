class CredentialsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_credential, only: %i[ show edit update destroy ]

  def search
    searchString = params[:search]
    @credentials = current_user.credentials
                                 .where('title ILIKE :search OR username ILIKE :search OR website ILIKE :search', search: "%#{searchString}%")
                                 .order(created_at: :desc)
    render :index
  end
    # GET /credentials or /credentials.json
  def index
    @credentials = current_user.credentials.order(created_at: :desc)
  end

  # GET /credentials/1 or /credentials/1.json
  def show
  end

  # GET /credentials/new
  def new
    @credential = Credential.new
  end

  # GET /credentials/1/edit
  def edit
  end

  # POST /credentials or /credentials.json
  def create
    @credential = Credential.new(credential_params)

    respond_to do |format|
      if @credential.save
        format.html { redirect_to credential_url(@credential), notice: "Credential was successfully created." }
        format.json { render :show, status: :created, location: @credential }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /credentials/1 or /credentials/1.json
  def update
    respond_to do |format|
      if @credential.update(credential_params)
        format.html { redirect_to credential_url(@credential), notice: "Credential was successfully updated." }
        format.json { render :show, status: :ok, location: @credential }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @credential.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credentials/1 or /credentials/1.json
  def destroy
    @credential.destroy!

    respond_to do |format|
      format.html { redirect_to credentials_url, notice: "Credential was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credential
      @credential = Credential.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def credential_params
      params.require(:credential).permit(:user_id, :title, :username, :password, :website)
    end
end
