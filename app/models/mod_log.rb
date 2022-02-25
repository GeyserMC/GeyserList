class ModLog < ApplicationRecord
  # The user who performed the action
  belongs_to :user
end
