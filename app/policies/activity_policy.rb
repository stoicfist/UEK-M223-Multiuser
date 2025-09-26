class ActivityPolicy < ApplicationPolicy
  def index?
    user&.role == "admin"
  end

  def show?
    index?
  end

  class Scope < Scope
    def resolve
      # Nur Admins dürfen überhaupt etwas sehen:
      return scope.none unless user&.role == "admin"
      scope.all
    end
  end
end