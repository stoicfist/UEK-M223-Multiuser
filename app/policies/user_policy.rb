class UserPolicy < ApplicationPolicy
  # Admin-Übersicht
  def index?
    user&.admin?
  end

  # Admin darf beliebige User bearbeiten; User darf sein eigenes Profil bearbeiten
  def update?
    user&.admin? || user == record
  end

  def edit?
    update?
  end

  # Rollen ändern nur Admin
  def update_role?
    user&.admin?
  end

  # Admin-Index-Scope
  class Scope < Scope
    def resolve
      user&.admin? ? scope.all : scope.none
    end
  end
end
