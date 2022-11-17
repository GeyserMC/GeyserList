class Report < ApplicationRecord
  # The user who created the report
  belongs_to :user

  # Return all open reports
  # @return [ActiveRecord::Relation<Report>]
  def self.open_reports
    Report.where(status: 'open')
  end
end
