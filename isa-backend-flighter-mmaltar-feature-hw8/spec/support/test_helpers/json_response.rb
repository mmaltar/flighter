module TestHelpers
  module JsonResponse
    def json_body
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
