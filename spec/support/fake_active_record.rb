class FakeActiveRecordPolicy < ApplicationPolicy
end

class FakeActiveRecordExistClass
  def exists?
    true
  end
end

class FakeActiveRecordNoExistClass
  def exists?
    false
  end
end

class FakeActiveRecord
  attr_accessor :id

  def initialize(id = true)
    @id = id
  end

  def self.where(params)
    params[:id] ? FakeActiveRecordExistClass.new : FakeActiveRecordNoExistClass.new
  end
end
