class Integration < ApplicationRecord
  belongs_to :user

  validates :kind, :data, presence: true

  crypt_keeper :data,
               encryptor: :mysql_aes_new,
               key: Rails.application.credentials.crypt[:key],
               salt: Rails.application.credentials.crypt[:salt]
end
