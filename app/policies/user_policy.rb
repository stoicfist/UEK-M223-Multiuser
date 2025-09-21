# app/policies/user_policy.rb
class UserPolicy < ApplicationPolicy
  # Zugriff auf /admin/users
  def index?
    admin? || moderator?  # Moderator darf z.B. lesen, aber nicht Rollen ändern
  end

  # Gäste dürfen Registrieren-Formular sehen & absenden
  def new?     = user.nil? || admin?
  def create?  = new?

  def show?
    admin? || owner?
  end

  def update?
    return true if admin?
    owner? # Nutzer darf nur sich selbst bearbeiten (ohne Rolle)
  end

  def update_role?
    admin? # ausschliesslich Admin
  end

  def destroy?
    admin? && !owner? # Admin darf alle ausser sich selbst löschen
  end

  class Scope < Scope
    def resolve
      if admin?
        scope.all
      elsif moderator?
        scope.where.not(role: "admin")
      else
        scope.where(id: user.id)
      end
    end
  end
end
