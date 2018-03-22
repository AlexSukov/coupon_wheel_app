class FacebookMobileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  #storage :file
  storage :fog

  process resize_to_limit: [300, 500]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    ActionController::Base.helpers.asset_path([version_name, "mobile-facebook.jpg"].compact.join('_'))
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

end
