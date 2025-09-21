module AuthorizationHelper
  def authorized_link_to(name, path, policy_obj, action, **opts, &block)
    return unless policy(policy_obj).public_send("#{action}?")
    link_to(name, path, **opts, &block)
  end
end
