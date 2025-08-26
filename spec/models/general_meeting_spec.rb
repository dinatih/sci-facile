# == Schema Information
#
# Table name: general_meetings
#
#  id           :integer          not null, primary key
#  date         :date
#  minutes_text :text
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :integer          not null
#
# Indexes
#
#  index_general_meetings_on_company_id  (company_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
require 'rails_helper'

RSpec.describe GeneralMeeting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
