module Overrides
  class RegistrationsController < DeviseTokenAuth::RegistrationsController
    layout 'empty'
  end
end
