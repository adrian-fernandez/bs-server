class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(
      File.read(Rails.root.join("config/routes/#{routes_name}.rb"))
    )
  end

  Rails.application.routes.draw do
    draw :frontend

    draw :api
  end
end