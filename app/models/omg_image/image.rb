# == Schema Information
#
# Table name: omg_image_images
#
#  id         :integer          not null, primary key
#  key        :string
#  created_at :datetime
#

module OmgImage
  class Image < ApplicationRecord
    has_one_attached :file
    validates :key, presence: true, length: {minimum: 1, maximum: 250}
  end
end
