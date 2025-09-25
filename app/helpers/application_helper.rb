module ApplicationHelper
  def can_edit_template?(template)
    current_user && (current_user.admin? || template.user == current_user)
  end
end