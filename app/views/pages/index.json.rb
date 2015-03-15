#json.array!(@pages) do |page|
#  json.extract! page, :id, :name, :slug, :content
#  json.url page_url(page, format: :json)
#end

@pages.map do |page|
  {
      name: page.name,
      created_at: page.created_at,
      url: page_url(page),
      # reviews: product.reviews.map { |r| JSON.parse(render(r)) }
      # reviews/_review.json.rb
  }
end.to_json