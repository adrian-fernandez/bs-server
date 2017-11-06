module ValidationErrorPayload
  def validation_error_payload(*fields_with_messages)
    errors = {}
    fields_with_messages.each do |field_with_messages|
      if field_with_messages[1].is_a?(Array)
        errors[field_with_messages[0].to_s] = field_with_messages[1].map do |message|
          format_message_from_array(message)
        end
      elsif field_with_messages[1].is_a?(String)
        errors[field_with_messages[0].to_s] = [I18n.t(field_with_messages[1])]
      elsif field_with_messages[1].is_a?(Hash)
        errors[field_with_messages[0].to_s] = [prepend_and_append(field_with_messages[1])]
      end
    end
    {
      'errors' => errors
    }
  end

  private

    def format_message_from_array(message)
      if message.is_a?(String)
        I18n.t(message)
      elsif message.is_a?(Hash)
        prepend_and_append(message)
      end
    end

    def prepend_and_append(hash_message)
      [
        hash_message[:prepend],
        I18n.t(hash_message[:message], hash_message[:key] => hash_message[:value]), hash_message[:append]
      ].join
    end
end

RSpec.configure do |config|
  config.include ValidationErrorPayload, type: :request
end
