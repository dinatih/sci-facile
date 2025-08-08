json.extract! general_meeting, :id, :company_id, :date, :title, :minutes_text, :created_at, :updated_at
json.url general_meeting_url(general_meeting, format: :json)
