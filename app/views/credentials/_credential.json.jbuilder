json.extract! credential, :id, :user_id, :title, :username, :password, :website, :created_at, :updated_at
json.url credential_url(credential, format: :json)
