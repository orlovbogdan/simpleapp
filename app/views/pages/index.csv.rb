response.headers["Content-Disposition"] = 'attachment; filename="page.csv"'

CSV.generate do |csv|
  csv << ["Name", "Time", "URL"]
  @pages.each do |page|
    csv << [
        page.name,
        page.created_at,
        page_url(page)
    ]
  end
end