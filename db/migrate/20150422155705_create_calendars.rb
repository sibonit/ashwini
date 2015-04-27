class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.integer :eventId
      t.date :startDate
      t.time :startTime
      t.date :endDate
      t.time :endTime
      t.string :titleLong
      t.string :titleLink
      t.text :locationText
      t.text :sponsorText
      t.text :contactNameText
      t.string :contactEmail
      t.string :contactPhone
      t.string :eventType
      t.string :originatingCalendarName

      t.timestamps null: false
    end
  end
end
