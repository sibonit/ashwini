module ApplicationHelper

 # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Ashwini's Testing Site"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

 # Calendar Events
  def top_five_calendar_events
    previous_date = ''
    $midnight_today = Time.now.at_midnight
    @calendar_events = CalendarEvent.current( $midnight_today ).top_5


    out = '<div style="padding-bottom: 9px;">'
    @calendar_events.each do |e|
      unless previous_date == e.startDate
        fields = e.startDate.split( '/' )
        event_date = Date.new( fields[ 2 ].to_i, fields[ 0 ].to_i, fields[ 1 ].to_i )
        out += '<h3 class="dayHeader" style="padding-top: 0">'
        out += event_date.strftime( '%A, %B %d, %Y' )
        out += '</h3>'
      end

      out += '<p class="">'
      out += "<span style=\"font-size: 0.7em\">#{ e.startTime } </span>" unless e.startTime.blank?
      out += link_to e.titleLong, "http://illinois.edu/calendar/detail/1233?eventId=#{ e.eventId }"
      out += '</p>'

      previous_date = e.startDate
    end
    out += '</div>'
    out.html_safe

  end

  def top_mip_calendar_events
    previous_date = ''
    $midnight_today = Time.now.at_midnight
    @calendar_events = CalendarEvent.current( $midnight_today ).top_5.mip

    out = '<div style="padding-bottom: 9px;">'
    @calendar_events.each do |e|
      unless previous_date == e.startDate
        fields = e.startDate.split( '/' )
        event_date = Date.new( fields[ 2 ].to_i, fields[ 0 ].to_i, fields[ 1 ].to_i )
        out += '<h3 class="dayHeader" style="padding-top: 0">'
        out += event_date.strftime( '%A, %B %d, %Y' )
        out += '</h3>'
      end

      out += '<p class="">'
      out += "<span style=\"font-size: 0.7em\">#{ e.startTime } </span>" unless e.startTime.blank?
      out += link_to e.titleLong, "http://illinois.edu/calendar/detail/1233?eventId=#{ e.eventId }"
      out += '</p>'

      previous_date = e.startDate
    end
    out += '</div>'
    out.html_safe

  end





end
