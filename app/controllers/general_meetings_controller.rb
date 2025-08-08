class GeneralMeetingsController < ApplicationController
  before_action :set_general_meeting, only: %i[ show edit update destroy ]

  # GET /general_meetings or /general_meetings.json
  def index
    @general_meetings = GeneralMeeting.all
  end

  # GET /general_meetings/1 or /general_meetings/1.json
  def show
  end

  # GET /general_meetings/new
  def new
    @general_meeting = GeneralMeeting.new
  end

  # GET /general_meetings/1/edit
  def edit
  end

  # POST /general_meetings or /general_meetings.json
  def create
    @general_meeting = GeneralMeeting.new(general_meeting_params)

    respond_to do |format|
      if @general_meeting.save
        format.html { redirect_to @general_meeting, notice: "General meeting was successfully created." }
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
        format.html { redirect_to @general_meeting, notice: "General meeting was successfully updated." }
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
      format.html { redirect_to general_meetings_path, status: :see_other, notice: "General meeting was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_general_meeting
      @general_meeting = GeneralMeeting.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def general_meeting_params
      params.expect(general_meeting: [ :company_id, :date, :title, :minutes_text ])
    end
end
