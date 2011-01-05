module HomeHelper
  def remote_sign_in_link_to(app)
    if session[:remote_session][app.key]
      output = link_to app.name, finalize_login_path(app.key)
      unless app.passthru?
        output += "&mdash;click again to finish. Only the newer apps do one-click sign in.".html_safe
      end
    else
      output = link_to(app.name, app.login_url)
      unless app.passthru?
        output += "&mdash;click this link, \"Log in\" on the home page, then this link again".html_safe
      end
    end
    output
  end
end
