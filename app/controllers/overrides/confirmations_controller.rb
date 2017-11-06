module Overrides
  class ConfirmationsController < DeviseTokenAuth::ConfirmationsController
    layout 'empty'
  end
end
