class TemplatePolicy < ApplicationPolicy
  def index?   = true
  def show?    = record.visibility == "public" || owner? || user&.role_admin?
  def create?  = user.present?
  def new?     = create?
  def update?  = owner? || user&.role_admin?
  def edit?    = update?
  def destroy? = update?

  class Scope < Scope
    def resolve
      return scope.where(visibility: "public") unless user
      user.role_admin? ? scope.all :
        scope.where(visibility: "public").or(scope.where(user_id: user.id))
    end
  end
end
