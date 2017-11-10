module ApplicationHelper
  def is_active_controller(controller_name, class_name = nil)
    return class_name.nil? ? 'active' : class_name if params[:controller] == controller_name
    nil
  end

  def is_active_action(action_name)
    params[:action] == action_name ? 'active' : nil
  end
end
