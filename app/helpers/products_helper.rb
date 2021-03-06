module ProductsHelper
  def static_or_uploaded_image_tag(product, size, **options)
    return unless product.image.attached? || product.image_file_name.present?

    image_url = product.image.attached? ? product.image.variant(resize_and_pad: size) : "products/" + product.image_file_name
    image_tag(image_url, **options)
  end
end
