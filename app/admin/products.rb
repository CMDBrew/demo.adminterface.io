ActiveAdmin.register Product do
  menu priority: 2
  permit_params :title, :description, :author, :price, :featured, :available_on, :image_file_name, :image

  decorate_with Admin::ProductDecorator

  scope :all, default: true, show_count: false
  scope :available
  scope :drafts
  scope :featured

  form html: {multipart: true} do |f|
    panel do
      f.inputs do
        f.semantic_errors

        f.input :featured, as: :switch
        f.input :title
        f.input :description
        f.input :author
        f.input :price
        f.input :available_on, as: :date_picker
        f.input :image, as: :file

        f.actions
      end
    end
  end

  preserve_default_filters!
  remove_filter :image_attachment
  remove_filter :image_blob
  remove_filter :image_file_name

  index do
    selectable_column
    column :title do |product|
      text_node static_or_uploaded_image_tag(product, [32, 32], width: 32, height: 32)
      a truncate(product.title), href: admin_product_path(product)
    end
    column :created_at
    actions
  end

  index as: :grid do |product|
    div do
      resource_selection_cell product
      a href: admin_product_path(product) do
        static_or_uploaded_image_tag(product, [115, 115])
      end
    end
    a truncate(product.title), href: admin_product_path(product)
  end

  show title: :title do |resource|
    columns(class: "mb-3 g-3") do
      column(span: 6) do
        panel t(:total_orders, scope: "admin.products.panels"), class: "mb-0" do
          h3 Order.find_with_product(resource).count
        end
      end

      column(span: 6) do
        panel t(:total_price, scope: "admin.products.panels"), class: "mb-0" do
          h3 number_to_currency LineItem.where(product_id: resource.id).sum(:price)
        end
      end
    end

    attributes_table do
      row :featured
      row :available_on
      row :title
      row :author
      row(:price) { |u| number_to_currency u.price }
      row :description
      row :created_at
      row :updated_at
    end

    panel t(:recent_orders, scope: "admin.products.panels"), body_html: {class: "p-0"} do
      div class: "list-group list-group-flush" do
        Order.find_with_product(resource).limit(5).each do |order|
          li auto_link(order), class: "list-group-item"
        end
      end
    end
  end
end
