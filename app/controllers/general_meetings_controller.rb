class GeneralMeetingsController < ApplicationController
  before_action :set_company
  before_action :set_general_meeting, only: %i[ show edit update destroy ]

  # GET /general_meetings or /general_meetings.json
  def index
    @general_meetings = @company.general_meetings
  end

  # GET /general_meetings/1 or /general_meetings/1.json
  def show
  end

  # GET /general_meetings/new
  def new
    @general_meeting = @company.general_meetings.build
  end

  # GET /general_meetings/1/edit
  def edit
  end

  # POST /general_meetings or /general_meetings.json
  def create
    @general_meeting = @company.general_meetings.build(general_meeting_params)

    respond_to do |format|
      if @general_meeting.save
        format.html { redirect_to [ @company, @general_meeting ], notice: "General meeting was successfully created." }
        format.json { render :show, status: :created, location: @general_meeting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @general_meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /general_meetings/1 or /general_meetings/1.json
  def update
    respond_to do |format|
      if @general_meeting.update(general_meeting_params)
        format.html { redirect_to [ @company, @general_meeting ], notice: "General meeting was successfully updated." }
        format.json { render :show, status: :ok, location: @general_meeting }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @general_meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /general_meetings/1 or /general_meetings/1.json
  def destroy
    @general_meeting.destroy!

    respond_to do |format|
      format.html { redirect_to company_general_meetings_path(@company), status: :see_other, notice: "General meeting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_company
      @company = Company.find(params[:company_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_general_meeting
      @general_meeting = @company.general_meetings.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def general_meeting_params
      params.expect(general_meeting: [ :company_id, :date, :title, :minutes_text ])
    end
end
