ActiveAdmin.register UserAddress do
  belongs_to :user
  decorate_with Admin::UserAddressDecorator

  permit_params :fullname, :address_line1, :address_line2, :city, :state, :zip_code, :country

  preserve_default_filters!
  remove_filter :user
  filter :country, as: :select, tom_select: true

  index do
    selectable_column
    id_column
    column(:fullname)
    column(:address_line1)
    column(:city)
    column(:state)
    column(:zip_code)
    column(:country)
    actions
  end

  show do
    attributes_table do
      row(:user) { |u| auto_link u.user, u.user_avatar_with_name }
      row :fullname
      row :full_address
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    panel do
      f.inputs do
        f.input :fullname
        f.input :address_line1
        f.input :address_line2

        columns do
          column(span: 6) { f.input :city }
          column(span: 6) { f.input :state }
          column(span: 6) { f.input :zip_code }
          column(span: 6) { f.input :country }
        end
      end
      f.actions
    end
  end
end
