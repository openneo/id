module ApplicationHelper
  def nav_link(content, path)
    link_to_unless_current content, path do
      content_tag :span, content
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
