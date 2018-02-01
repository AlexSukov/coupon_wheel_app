class FacebookDesktopUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file

  process resize_to_limit: [600, 400]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    ActionController::Base.helpers.asset_path([version_name, "desktop-facebook.png"].compact.join('_'))
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

end
