json.extract! publication, :id, :title, :author, :year, :wellcome_id, :created_at, :updated_at
json.url publication_url(publication, format: :json)