class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def create?
    true
  end

  def show?
    user == record
  end

  def update?
    user == record
  end

  def destroy?
    user == record
  end
end
