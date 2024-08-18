module CredentialList
  class Base < Grape::API
    mount CredentialList::V1::Credentials
  end
end
