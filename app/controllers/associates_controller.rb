class AssociatesController < ApplicationController
  before_action :set_company
  before_action :set_associate, only: %i[ show edit update destroy ]

  # GET /associates or /associates.json
  def index
    @associates = @company.associates
  end

  # GET /associates/1 or /associates/1.json
  def show
  end

  # GET /associates/new
  def new
    @associate = @company.associates.build
  end

  # GET /associates/1/edit
  def edit
  end

  # POST /associates or /associates.json
  def create
    @associate = @company.associates.build(associate_params)

    respond_to do |format|
      if @associate.save
        format.html { redirect_to [ @company, @associate ], notice: "Associate was successfully created." }
        format.json { render :show, status: :created, location: @associate }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @associate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /associates/1 or /associates/1.json
  def update
    respond_to do |format|
      if @associate.update(associate_params)
        format.html { redirect_to [ @company, @associate ], notice: "Associate was successfully updated." }
        format.json { render :show, status: :ok, location: @associate }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @associate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /associates/1 or /associates/1.json
  def destroy
    @associate.destroy!

    respond_to do |format|
      format.html { redirect_to company_associates_path(@company), status: :see_other, notice: "Associate was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  protected

  def after_sign_up_path_for(resource)
    company_associates_path(resource.company)
  end

  private
    def set_company
      @company = Company.find(params.expect(:company_id))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_associate
      @associate = @company.associates.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def associate_params
      params.expect(associate: [  :company_id, :first_name, :last_name, :email, :shares_count,
                                  :initial_contribution, :current_account_balance, :password, :password_confirmation ])
    end
end
