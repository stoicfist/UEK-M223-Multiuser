class DocumentPolicy < ApplicationPolicy
  def index? = true
  def show?    = owner? || user&.role_admin?
  def create?  = user.present?
  def new?     = create?
  def update?  = owner? || user&.role_admin?
  def destroy? = update?

  class Scope < Scope
    def resolve
      return scope.none unless user
      user.role_admin? ? scope.all : scope.where(user_id: user.id)
    end
  end
end
