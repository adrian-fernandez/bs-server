module Overrides
  class SessionsController < DeviseTokenAuth::SessionsController
    layout 'empty'
  end
end
