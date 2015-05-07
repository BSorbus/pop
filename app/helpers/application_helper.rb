module ApplicationHelper

  # Bootstrap 3 helpers for Rails 4 Flash messages
  # in Gemfile add line: gem 'bootstrap-sass', '~> 3.2.0'
  # and <%= flash_messages %> in views/layouts/application.html.erb
  # use in controllers: flash[:error] = 'Invalid email/password combination'

  # oryginal  
  #def bootstrap_class_for flash_type
  #  { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  #end
  # customize icons for each flash type
  #def bootstrap_icon_for flash_type
  #  { success: "ok-sign", error: "exclamation-sign", alert: "warning-sign", notice: "info-sign" }[flash_type] || "question-sign"
  #end


  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type] || flash_type.to_s
  end

  # customize icons for each flash type
  def bootstrap_icon_for flash_type
    { success: "ok-sign", error: "exclamation-sign", alert: "warning-sign", notice: "info-sign" }[flash_type] || "question-sign"
  end

  def bootstrap_close_alert_button_tag
    button_tag(type: 'button', class: "close", data: { dismiss: 'alert' }) do
      concat content_tag(:span, '&times;'.html_safe, 'aria-hidden' => 'true')
      concat content_tag(:span, 'Close', class: "sr-only")
    end
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type.to_sym)} alert-dismissible", role: "alert") do 
        concat bootstrap_close_alert_button_tag
        concat content_tag(:i, nil, class: "glyphicon glyphicon-#{bootstrap_icon_for(msg_type.to_sym)}")
        concat " "
        concat message
      end)
    end
    nil
  end




  include ActionView::Helpers::NumberHelper
  def with_delimiter_and_separator(value)
    number_with_precision(value, precision: 2, separator: ',', delimiter: ' ')
  end

  def without_separator_and_zero(value)
    number_with_precision(value, precision: 0, delimiter: '')
  end
  
end
