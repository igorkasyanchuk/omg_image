module OmgImage
  class Image < ApplicationRecord
    has_one_attached :file
    validates :key, presence: true
  end
end
