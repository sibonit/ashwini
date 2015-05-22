class CalendarEvent < ActiveRecord::Base

  default_scope { order( 'start' ) }

  scope :current, ->(midnight_today) { where("end >= ?", midnight_today) }
  scope :next_13_months, ->(midnight_today) { where("start <= ?", midnight_today + 13.months) }
  scope :top_5, -> { limit(5) }
  scope :mip, -> { where("originatingCalendarName = 'Molecular and Integrative Physiology (MIP) Department Seminar Series'") }
  scope :candidates, -> { where("titleLong LIKE '%Faculty Search Candidate%'") }

  def same?( o )
    return false if o.nil?

    # two CalendarEvent objects are the same if following fields match
    fields = %w[ eventId
                 startDate
                 startTime
                 endDate
                 endTime
                 titleLong
                 titleLink
                 locationText
                 sponsorText
                 contactNameText
                 contactEmail
                 contactPhone
                 eventType
                 originatingCalendarName
               ]

    fields.each do |field|
      if self.send( field ) != o.send( field )
        # as soon as something doesn't match
        return false
      end
    end

    # everything matched
    return true
  end

end
