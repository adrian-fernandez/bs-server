module ClientPayload
  def client_payload(client)
    {
      'client' => {
        'id' => client.id,
        'name' => client.name
      }
    }
  end

  def clients_payload(clients)
    array = clients.map { |item| client_payload(item)['client'] }

    {
      'clients' => array,
      'meta' => { 'total_pages' => 1, 'current_page' => 0 }
    }
  end
end

RSpec.configure do |config|
  config.include ClientPayload, type: :request
end
