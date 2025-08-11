class CompaniesController < ApplicationController
  before_action :set_company, only: %i[ show edit update destroy ]

  # GET /companies or /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1 or /companies/1.json
  def show
    period = params[:period] || "year"
    start_date, end_date = period_dates(period)

    ops = @company.financial_operations.where(date: start_date..end_date)

    @total_income = ops.where(category: "recette").sum(:amount)
    @total_expense = ops.where(category: "dépense").sum(:amount)
    @current_balance = @total_income - @total_expense

    # Graph: income vs expenses by month
    # @monthly_data = ops.group_by_month(:date, format: "%b %Y").sum(:amount)
    @monthly_income  = ops.where(category: "recette").group_by_month(:date, format: "%b %Y").sum(:amount)
    @monthly_expense = ops.where(category: "dépense").group_by_month(:date, format: "%b %Y").sum(:amount)

    # Top properties income
    @top_properties_income = @company.properties.joins(:financial_operations)
                                     .where(financial_operations: { category: "recette", date: start_date..end_date })
                                     .group(:id, :address)
                                     .sum("financial_operations.amount")
                                     .sort_by { |_k, v| -v }
                                     .first(5)
  end

  def period_dates(period)
    case period
    when "month"
      [ Date.today.beginning_of_month, Date.today.end_of_month ]
    when "quarter"
      [ Date.today.beginning_of_quarter, Date.today.end_of_quarter ]
    else # year
      [ Date.today.beginning_of_year, Date.today.end_of_year ]
    end
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies or /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: "Company was successfully created." }
        format.json { render :show, status: :created, location: @company }
      else
            Rails.logger.error "Company errors: #{@company.errors.full_messages}"
  rescue_from StandardError do |exception|
    Rails.logger.error exception.full_message
    raise exception
  end

        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1 or /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: "Company was successfully updated." }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1 or /companies/1.json
  def destroy
    @company.destroy!

    respond_to do |format|
      format.html { redirect_to companies_path, status: :see_other, notice: "Company was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def company_params
      params.expect(company: [ :name ])
    end
end
