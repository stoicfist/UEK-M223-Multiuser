# frozen_string_literal: true
module PaperTrail
  class VersionPolicy < ApplicationPolicy
    # Nur Admins dürfen den Feed sehen
    def index?
      user&.role == "admin"
    end

    def show?
      index?
    end

    class Scope < Scope
      def resolve
        return scope.none unless user&.role == "admin"
        scope.all
      end
    end
  end
end
