module ApplicationHelper
  def title(new_title=nil)
    if new_title
      @title = new_title
    else
      @title || 'Welcome!'
    end
  end
end
