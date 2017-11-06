class Api::V1::BaseController < ApplicationController
  before_action :require_login
  before_action :find_item, only: %i[show update destroy]
  before_action :set_paper_trail_whodunnit

  PER_PAGE = 10

  def index
    authorize authorizer
    repository = object_repository.new(
      current_client: current_client,
      current_user: current_user,
      params: params
    )

    render json: repository.collection,
           excluded_attributes: params[:excluded_attributes],
           meta: repository.meta,
           each_serializer: object_serializer
  end

  def create
    authorize authorizer

    service = object_service.new(
      current_client: current_client,
      current_user: current_user,
      params: params
    )

    if service.create
      render json: service.item, status: 201
    else
      render json: { errors: service.item.errors }, status: 422
    end
  end

  def show
    authorize @item

    render json: @item, root: root_for_json
  end

  def update
    authorize @item

    service = object_service.new(
      item: @item,
      current_client: current_client,
      current_user: current_user,
      params: params
    )

    if service.update
      render json: service.item, root: root_for_json
    else
      render json: { errors: service.item.errors }, status: 422
    end
  end

  def destroy
    authorize @item

    @item.destroy
    render json: {}, status: 204
  end

  protected

    def pundit_user
      UserPunditContext.new(current_user, params)
    end

    def render_not_authorized
      render json: { errors: 'Not Found' }, status: 401
    end

    def set_csrf_cookie
      cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
    end

    def find_item
      @item = model.find(params[:id])
    end

    def object_repository
      Object.const_get("Api::V1::Repositories::#{object.to_s.camelize.pluralize}Repository")
    end

    def object_service
      Object.const_get("Api::V1::Services::#{object.to_s.camelize}Service")
    end

    def object_serializer
      Object.const_get("#{object.to_s.camelize}Serializer")
    end

    def model
      object.to_s.camelize.constantize
    end

    def root_for_json
      object.to_s
    end

    def authorizer
      object
    end

    def set_paper_trail_whodunnit
      current_user&.id || 'Unknown user'
    end
end
