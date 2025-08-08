class FinancialOperationsController < ApplicationController
  before_action :set_company
  before_action :set_financial_operation, only: %i[ show edit update destroy ]

  # GET /financial_operations or /financial_operations.json
  def index
    @financial_operations = @company.financial_operations
  end

  # GET /financial_operations/1 or /financial_operations/1.json
  def show
  end

  # GET /financial_operations/new
  def new
    @financial_operation = @company.financial_operations.build
  end

  # GET /financial_operations/1/edit
  def edit
  end

  # POST /financial_operations or /financial_operations.json
  def create
    @financial_operation = @company.financial_operations.build(financial_operation_params)

    respond_to do |format|
      if @financial_operation.save
        format.html { redirect_to [ @company, @financial_operation ], notice: "Financial operation was successfully created." }
        format.json { render :show, status: :created, location: @financial_operation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @financial_operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /financial_operations/1 or /financial_operations/1.json
  def update
    respond_to do |format|
      if @financial_operation.update(financial_operation_params)
        format.html { redirect_to [ @company, @financial_operation ], notice: "Financial operation was successfully updated." }
        format.json { render :show, status: :ok, location: @financial_operation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @financial_operation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /financial_operations/1 or /financial_operations/1.json
  def destroy
    @financial_operation.destroy!

    respond_to do |format|
      format.html { redirect_to company_financial_operations_path(@company), status: :see_other, notice: "Financial operation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_company
      @company = Company.find(params.expect(:company_id))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_financial_operation
      @financial_operation = @company.financial_operations.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def financial_operation_params
      params.expect(financial_operation: [ :company_id, :property_id, :tenant_id, :associate_id, :category, :label, :amount, :date ])
    end
end
