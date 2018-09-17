class BookingPolicy < ApplicationPolicy
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
    user == record.user
  end

  def update?
    return true if user == record.user &&
                   Time.current <= record.flight.flys_at
    false
  end

  def destroy?
    user == record.user
  end
end
