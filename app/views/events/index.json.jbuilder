json.array!(@events) do |event|
  #json.extract! event, :title, :start_date, :end_date, :url_action
  json.title event.title
  json.allDay event.allday
  json.start event.start_date.to_formatted_s(:db)
  json.end event.end_date.to_formatted_s(:db)
  json.color event.color 
  json.url event.url_action.present? ? event.url_action : event_url(event, format: :html)
end
