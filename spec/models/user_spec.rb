# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  email                 :string(255)
#  provider              :string(255)
#  uid                   :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  notify_on_all_actions :boolean          default(FALSE)
#

require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
