json.(@user, :id, :name, :email)

json.identities @user.identities, :id, :user_id, :provider, :uid

json.root_url root_url
