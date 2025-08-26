# == Schema Information
#
# Table name: associates
#
#  id                      :integer          not null, primary key
#  current_account_balance :decimal(10, 2)   default(0.0), not null
#  current_sign_in_at      :datetime
#  current_sign_in_ip      :string
#  email                   :string           default(""), not null
#  encrypted_password      :string           default(""), not null
#  first_name              :string
#  initial_contribution    :decimal(10, 2)   default(0.0)
#  last_name               :string
#  last_sign_in_at         :datetime
#  last_sign_in_ip         :string
#  remember_created_at     :datetime
#  reset_password_sent_at  :datetime
#  reset_password_token    :string
#  shares_count            :integer          default(0), not null
#  sign_in_count           :integer          default(0), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  company_id              :integer          not null
#
# Indexes
#
#  index_associates_on_company_id            (company_id)
#  index_associates_on_email                 (email) UNIQUE
#  index_associates_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
require 'rails_helper'

RSpec.describe Associate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
