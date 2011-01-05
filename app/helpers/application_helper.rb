module ApplicationHelper
  def app_state_form_for(*args, &block)
    if @app
      semantic_form_for(*args) do |form|
        hidden_field_tag('app', @app.key) + capture(form, &block)
      end
    else
      semantic_form_for(*args, &block)
    end
  end
  
  def nav_link(content, route_name)
    route = Rails.application.routes.named_routes[route_name]
    if params[:controller] == route.defaults[:controller]
      content_tag :span, content
    else
      link_to content, send("#{route_name}_path", :app => @app.try(:key))
    end
  end
  
  def title(new_title=nil)
    if new_title
      @title = new_title
    else
      @title || 'Welcome!'
    end
  end
end
