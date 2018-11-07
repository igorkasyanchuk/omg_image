module OmgImage
  class Renderer
    def Renderer.render(template, layout: nil, locals: {})
      ::ApplicationController.render(
        file: "/#{Rails.root}/app/omg/#{template}",
        layout: layout,
        locals: locals
      )
    end
  end
end
