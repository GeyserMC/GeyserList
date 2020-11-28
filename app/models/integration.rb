class Integration < ApplicationRecord
  crypt_keeper :data,
               encryptor: :mysql_aes_new,
               key: Rails.application.credentials.crypt[:key],
               salt: Rails.application.credentials.crypt[:salt]
end
