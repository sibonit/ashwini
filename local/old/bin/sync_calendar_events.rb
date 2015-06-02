#!/usr/local/bin/ruby20
# -w prints lots of Rails errors

# FIX for: uninitialized constant ActiveSupport::Dependencies::Mutex (NameError)
#require 'thread'

# include libraries
#require "rexml/document"
require 'net/http'
#require 'rubygems'
require 'nokogiri'
require 'yaml'

# MCB Master Calendar
$url  = "http://illinois.edu/calendar/eventXML/4944.xml"


#RAILS_ENV = 'development'
#RAILS_ENV = 'production'
# Note new invocation for Ruby 2.0!
# (or at least old invocation doesn't work in Ruby 2.0)
ENV['RAILS_ENV'] = 'development'
#ENV['RAILS_ENV'] = 'production'
require File.dirname(__FILE__) + '/../../config/environment'

# only refresh current and future events if we receive 90% of the count of 
# events already in the database
$midnight_today = Time.now.at_midnight
$minimum_no_of_events_to_process = CalendarEvent.current( $midnight_today ).length * 0.9

$field_names = %w[
  eventId
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
# unused fields
#titleShort
#recurrence
#recurrenceId
#originatingCalendarId
#rss
#publicEngagement
#sponsorHtml
#dateDisplay
#timeType
#endTimeLabelText
#endTimeLabelHtml
#locationHtml
#searchTerms
#descriptionText
#descriptionHtml
#speakerText
#speakerHtml
#registrationLabel
#registrationUrl
#contactNameHtml
#costText
#costHtml
#createdBy
#createdDate
#editedBy
#editedDate



def main
  
  # get XML file via HTTP
#  cal_http = Net::HTTP.get( URI.parse( url ) )
  cal_http = Net::HTTP.get( URI( $url ) )
  # parse XML
  cal_xml = Nokogiri::XML( cal_http )
    
  # array to cache events before saving
  downloaded_events = Array.new

  # parse through all events
  cal_xml.xpath( '//publicEventWS' ).each do |e|
    c = CalendarEvent.new
    transfer_data_into_calendar_event( e, c )
    c.start = parse_date( c.startDate, c.startTime )
    c.end   = parse_date( c.endDate, c.endTime )

    downloaded_events << c
  end

  if downloaded_events.length >= $minimum_no_of_events_to_process
    #locally_stored_events = CalendarEvent.where( "end > ?", $midnight_today )
    locally_stored_events = CalendarEvent.current( $midnight_today )

    locally_stored_events.each do |c|
      # find downloaded event to match local
      e = downloaded_events.find { |e| e.eventId == c.eventId }

      # delete local event if not found in downloaded_events
      if e.nil?
        puts "Deleting unknown local event: c: #{ c.eventId }"
        c.delete
        next
      end
    
      # skip update if the events are the same
      # CalendarEvent.same? defined in app/models/calendar_event.rb
      unless e.same?( c )
        puts "Changed event: e: #{ e.eventId }   c: #{ c.eventId }"
        e.save 
        c.delete
      end

      # remove matching events
      downloaded_events.delete( e )
#      puts "downloaded_events.length: #{ downloaded_events.length }"
#      puts "events in db: #{ CalendarEvent.all.length }"
    end

    # downloaded events should now only contain new events
    downloaded_events.each do |e|
#      p e
      retval = e.save
      puts retval
      puts e.errors.full_messages
      p e
    end

  end
      
end # def main



def transfer_data_into_calendar_event( e, c )
  fields = Array.new
  $field_names.each do |f|
    value = e.at_xpath( f ).text
    value = nil if value == ''
    fields << value
  end

  c.eventId         = fields[ 0 ]
  c.startDate       = fields[ 1 ]
  c.startTime       = fields[ 2 ]
  c.endDate         = fields[ 3 ]
  c.endTime         = fields[ 4 ]
  c.titleLong       = fields[ 5 ]
  c.titleLink       = fields[ 6 ]
  c.locationText    = fields[ 7 ]
  c.sponsorText     = fields[ 8 ]
  c.contactNameText = fields[ 9 ]
  c.contactEmail    = fields[ 10 ]
  c.contactPhone    = fields[ 11 ]
  c.eventType       = fields[ 12 ]
  c.originatingCalendarName = fields[ 13 ]
end

def parse_date( date, time )
  month, day, year = date.split( '/' )
  month = month.to_i
  day = day.to_i
  year = year.to_i

  md = /(\d\d?):(\d\d) (am|pm)/.match( time )
  if md
    hours = md[ 1 ].to_i
    min   = md[ 2 ].to_i
    pm    = md[ 3 ] == 'pm'
    hours += 12 if hours < 12 and pm
  else
    # time will default to midnight if no time is present
    hours = 0
    min = 0
  end 
  Time.local( year, month, day, hours, min )
end

main()
