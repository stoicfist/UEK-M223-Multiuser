class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user   = user
    @record = record
  end

  def index?    = false
  def show?     = false
  def create?   = false
  def new?      = create?
  def update?   = false
  def edit?     = update?
  def destroy?  = false

  # Hilfs-Guards
  def admin?      = user&.role_admin?
  def moderator?  = user&.role_moderator?
  def owner?      = user && record.respond_to?(:id) && record.id == user.id

  def owner?
    return false unless user && record

    # 1) gleicher Objekt-Ref?
    return true if record.equal?(user)

    # 2) nur mit persistierten IDs vergleichen
    return false unless record.respond_to?(:id) && user.respond_to?(:id)
    record.id.present? && record.id == user.id
  end

  class Scope
    attr_reader :user, :scope
    def initialize(user, scope) = (@user, @scope = user, scope)
    def resolve = scope.none
  end
end
