class Post < ApplicationRecord

  has_one_attached :preview

  def Post.create_new_preview
    processor = ::OmgImage::Processor.new('entity', title: "OMG,<br/>this is created from model", description: "Small version", size: '400,200')
    processor.generate do |output|
      post = Post.new
      post.preview.attach(io: File.open(output.path), filename: "image.png", content_type: "image/png")
      post.save!
    end
  end

  def preview_on_disk
    ActiveStorage::Blob.service.send(:path_for, preview.key)
  end

end
