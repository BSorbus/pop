json.array!(@events) do |event|
  #json.extract! event, :title, :start, :end, :url_action
  json.title event.title
  json.start event.start.to_formatted_s(:db)
  json.end event.end.to_formatted_s(:db)
  json.allDay event.allday
  json.url_action event.url_action
  json.color event.url_action.present? ? '#a4bacc' : '#89877a'
  json.url event.url_action.present? ? event.url_action : event_url(event, format: :html)
end
