require "#{Rails.root}/lib/client_scope"

class Client < ApplicationRecord
  include ClientScope
  has_paper_trail

  validates :name, presence: true, uniqueness: true

  class << self
    def can_restore_password?
      false
    end

    def can_self_register?
      false
    end
  end
end
