class LatexTemplatePolicy < ApplicationPolicy
  def index?   = true
  def show?    = record.visibility == "public" || owner? || user&.role_admin?
  def create?  = user.present?
  def new?     = create?
  def update?  = owner? || user&.role_admin?
  def edit?    = update?
  def destroy? = update?

  # <<< Custom-Action-Rechte >>>
  def new_document?      = show?           # Wer das Template sehen darf, darf das Formular öffnen
  def create_document?   = user.present?   # Nur eingeloggte dürfen Dokumente erzeugen
  def clone_to_document? = show?           # Wer sehen darf, darf klonen

  class Scope < Scope
    def resolve
      if user&.role_admin?
        scope.all
      elsif user
        scope.where("visibility = ? OR user_id = ?", "public", user.id)
      else
        scope.where(visibility: "public")
      end
    end
  end
end
