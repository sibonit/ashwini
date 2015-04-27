class CalendarController < ApplicationController

  def index
    $midnight_today = Time.now.at_midnight
    @calendar_events = Calendar.current( $midnight_today ).next_13_months( $midnight_today )
  end

  def candidates
    $midnight_today = Time.now.at_midnight
    @calendar_events = Calendar.current( $midnight_today ).candidates.next_13_months( $midnight_today )
    render :index
  end



end



