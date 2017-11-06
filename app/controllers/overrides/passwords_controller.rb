module Overrides
  class PasswordsController < DeviseTokenAuth::PasswordsController
    layout 'empty'
  end
end
