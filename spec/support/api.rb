module ApiHelpers
  def json
    @json ||= JSON.parse(response.body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include ApiHelpers, type: :request

  config.before(:each) do
    @client = FactoryGirl.create(:client, name: 'client name')
    ActsAsTenant.current_tenant = @client

    # STAFF USER - Admin
    @admin_role = Role.find_or_create_by(name: 'admin', client: @client)
    @admin_role.permissions = {
      admin: true,
      rentals: {
        index: true, show: true, create: true, update: true, destroy: true
      },
      bookings: {
        index: true, show: true, create: true, update: true, destroy: true
      },
      users: {
        index: true, show: true, create: true, update: true, destroy: true
      }
    }
    @admin_role.save
    @admin_user = FactoryGirl.create(:user, password: 'password', password_confirmation: 'password', client: @client)
    @admin_user.roles << @admin_role

    # CUSTOMER USER
    @staff_role = Role.find_or_create_by(name: 'user', client: @client)
    @staff_role.permissions = {
      admin: false,
      rentals: {
        index: true, show: true, create: true, update: :self, destroy: :self
      },
      bookings: {
        index: true, show: :self, create: true, update: :self, destroy: :self
      },
      users: {
        index: false, show: true, create: false, update: :self, destroy: :self
      }
    }
    @staff_role.save
    @staff_user = FactoryGirl.create(:user, password: 'password', password_confirmation: 'password', client: @client)
    @staff_user.roles << @staff_role

    # SUPERADMIN USER
    @superadmin_role = Role.find_or_initialize_by(name: 'superadmin', client: @client)
    @superadmin_role.permissions = {
      admin: false,
      rentals: {
        index: true, show: true, create: true, update: true, destroy: true
      },
      bookings: {
        index: true, show: true, create: true, update: true, destroy: true
      },
      users: {
        index: true, show: true, create: true, update: true, destroy: true
      }
    }
    @superadmin_role.save(validate: false)

    @superadmin_user = FactoryGirl.create(:user, password: 'password', password_confirmation: 'password', client: @client)
    @superadmin_user.roles << @superadmin_role
  end

  config.before(:each, type: :request) do
    @staff_user_session = create :user_session, user: @staff_user, accessed_at: 1.minute.ago
    @admin_user_session = create :user_session, user: @admin_user, accessed_at: 1.minute.ago
    @superadmin_user_session = create :user_session, user: @superadmin_user, accessed_at: 1.minute.ago
  end
end

RSpec::Matchers.define :match_json_schema do |schema|
  match do |response|
    schema_directory = "#{Dir.pwd}/spec/support/api/v1/schemas"
    schema_path = "#{schema_directory}/#{schema}.json"
    # puts response.body
    JSON::Validator.validate!(schema_path, response.body, version: :draft2)
  end
end

RSpec::Matchers.define :match_json_payload do |payload|
  match do |response_body|
    # puts JSON.parse(response_body).inspect
    # puts payload.inspect
    JSON.parse(response_body) == payload
  end
end

RSpec::Matchers.define :match_json_payload do |payload|
  match do |response_body|
    response_hash = JSON.parse(response_body)

    return true if payload == response_hash

    deep_sort_array_or_hash = lambda do |object|
      case object
      when Hash
        object.values.each(&deep_sort_array_or_hash)
      when Array
        object.sort_by! { |e| e.is_a?(Hash) && e['id'].present? ? e['id'] : e }
        object.each(&deep_sort_array_or_hash)
      end
    end

    deep_sort_array_or_hash.call(payload)
    deep_sort_array_or_hash.call(response_hash)

    return true if payload == response_hash
  end

  failure_message do |response_body|
    response_hash = JSON.parse(response_body)

    <<-EOF.strip_heredoc
      expected

      #{JSON.pretty_generate(payload)}

      to match the received json from server

      #{JSON.pretty_generate(response_hash)}


      ---

      Difference:

      #{HashDiff.diff(payload, response_hash)}
    EOF
  end

  failure_message_when_negated do |response_body|
    response_hash = JSON.parse(response_body)

    <<-EOF.strip_heredoc
      expected

      #{JSON.pretty_generate(payload)}

      not to match the received json from server

      #{JSON.pretty_generate(response_hash)}
    EOF
  end
end

RSpec.shared_examples 'forbidden' do |method, url_to_check, headers|
  it 'is forbidden' do
    headers ||= {}
    send method.to_sym, url_to_check, params: {}, headers: headers
    expect(response.status).to eq(401)
  end
end
