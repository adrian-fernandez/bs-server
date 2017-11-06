class ObjectsGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :model, type: :string
  argument :api_version, type: :string

  def generate_model
    generate_model_object
  end

  def generate_model_spec
    generate_model_spec_object
  end

  def generate_controller
    generate_controller_object
  end

  def generate_policy
    generate_policy_object
  end

  def generate_policy_spec
    generate_policy_spec_object
  end

  def generate_serializer
    generate_serializer_object
  end

  def generate_service_filter
    generate_service_filter_object
  end

  def generate_service_filter_spec
    generate_service_filter_spec_object
  end

  def generate_service_repository
    generate_service_repository_object
  end

  def generate_service_repository_spec
    generate_service_repository_spec_object
  end

  def generate_service_sorter
    generate_service_sorter_object
  end

  def generate_service_sorter_spec
    generate_service_sorter_spec_object
  end

  def generate_migration
    generate_migration_object
  end

  def generate_request_spec
    generate_request_spec_object
  end

  def generate_payload
    generate_payload_object
  end

  def generate_schema
    generate_schema_object
  end

  def generate_factory_girl
    generate_factory_girl_object
  end

  private

    def generate_model_object
      copy_file(
        'model_object_template.template',
        "app/models/#{model.underscore}.rb"
      )
    end

    def generate_model_spec_object
      copy_file(
        'model_spec_object_template.template',
        "spec/models/#{model.underscore}_spec.rb"
      )
    end

    def generate_controller_object
      copy_file(
        'controller_object_template.template',
        "app/controllers/api/#{api_version.downcase}/#{model.underscore}.rb"
      )
    end

    def generate_policy_object
      copy_file(
        'policy_object_template.template',
        "app/policies/#{model.underscore}_policy.rb"
      )
    end

    def generate_policy_spec_object
      copy_file(
        'policy_spec_object_template.template',
        "spec/policies/#{model.underscore}_policy_spec.rb"
      )
    end

    def generate_serializer_object
      copy_file(
        'model_serializer_object_template.template',
        "app/models/#{model.underscore}_serializer.rb"
      )
    end

    def generate_service_filter_object
      copy_file(
        'service_filter_object_template.template',
        "app/services/api/<%= api_version.downcase %>/filters/#{model.underscore}_filter.rb"
      )
    end

    def generate_service_filter_spec_object
      copy_file(
        'service_filter_spec_object_template.template',
        "spec/services/api/<%= api_version.downcase %>/filters/#{model.underscore}_filter_spec.rb"
      )
    end

    def generate_service_repository_object
      copy_file(
        'service_repository_object_template.template',
        "app/services/api/<%= api_version.downcase %>/repositories/#{model.underscore}_repository.rb"
      )
    end

    def generate_service_repository_spec_object
      copy_file(
        'service_repository_spec_object_template.template',
        "spec/services/api/<%= api_version.downcase %>/repositories/#{model.underscore}_repository_spec.rb"
      )
    end

    def generate_service_sorter_object
      copy_file(
        'service_sorter_object_template.template',
        "app/services/api/<%= api_version.downcase %>/sorters/#{model.underscore}_sorter.rb"
      )
    end

    def generate_service_sorter_spec_object
      copy_file(
        'service_sorter_spec_object_template.template',
        "spec/services/api/<%= api_version.downcase %>/sorters/#{model.underscore}_sorter_spec.rb"
      )
    end

    def generate_service_service_object
      copy_file(
        'service_service_object_template.template',
        "app/services/api/<%= api_version.downcase %>/services/#{model.underscore}_service.rb"
      )
    end

    def generate_service_service_spec_object
      copy_file(
        'service_service_spec_object_template.template',
        "spec/services/api/<%= api_version.downcase %>/services/#{model.underscore}_service_spec.rb"
      )
    end

    def generate_migration_object
      generate "migration create_#{model.underscore.pluralize}"
    end

    def generate_request_spec_object
      copy_file(
        'request_spec_object_template.template',
        "spec/requests/api/<%= api_version.downcase %>/#{model.underscore.pluralize}_spec.rb"
      )
    end

    def generate_payload_object
      copy_file(
        'payload_object_template.template',
        "spec/support/api/<%= api_version.downcase %>/payload/#{model.underscore}_payload.rb"
      )
    end

    def generate_schema_object
      copy_file(
        'schema_object_template.template',
        "spec/support/api/<%= api_version.downcase %>/schemas/#{model.underscore}.json"
      )
      copy_file(
        'schemas_object_template.template',
        "spec/support/api/<%= api_version.downcase %>/schemas/#{model.underscore.pluralize}.json"
      )
    end

    def generate_factory_girl_object
      copy_file(
        'factory_girl_object_template.template',
        "spec/factories/#{model.underscore}.rb"
      )
    end
end
