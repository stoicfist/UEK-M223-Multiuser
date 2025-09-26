class ActivityPolicy < ApplicationPolicy
  # nur Admins dürfen überhaupt Aktivitäten sehen
  def index?
    user&.role == "admin"
  end

  def show?
    user&.role == "admin"
  end

  # falls du noch andere Actions brauchst:
  def create?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end

  # wichtig für policy_scope
  class Scope < Scope
    def resolve
      if user&.role == "admin"
        scope.all
      else
        scope.none
      end
    end
  end
end
