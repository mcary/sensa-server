module ApplicationHelper
  def nav_item(link_text, controller)
    class_opts = {}
    if controller.to_s == controller_name.to_s
      class_opts[:class] = "active"
    end
    return content_tag(:li, class_opts) do
      link_to link_text, url_for(:controller => controller)
    end
  end
end
