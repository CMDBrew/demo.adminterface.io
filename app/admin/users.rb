ActiveAdmin.register User do
  menu priority: 4
  decorate_with Admin::UserDecorator

  config.per_page = [10, 30]
  config.comments_per_page = 5

  # Index
  filter :name
  filter :email
  filter :created_at

  index do
    selectable_column
    id_column
    column(:name) { |u| u.avatar_with_name }
    column :email
    column :created_at
    actions
  end

  # Show
  show do
    tabs http: true, id: "user-tabs" do
      tab :profile do
        panel t(:info, scope: "admin.users.panels") do
          attributes_table_for resource do
            row(:name) { |u| u.avatar_with_name }
            row :email
            row :biography
            row :created_at
          end
        end

        panel UserAddress.model_name.human(count: 2) do
          header_action do
            div class: "btn-group" do
              safe_join [
                link_to(t(:new_model, scope: "active_admin", model: UserAddress.model_name.human), new_admin_user_user_address_path(user), class: "btn btn-sm btn-link")
              ]
            end
          end

          div class: "table-responsive" do
            table_for(user.user_addresses) do
              column(:fullname) do |a|
                link_to a.fullname.to_s, admin_user_user_address_path(user.id, a.id)
              end
              column(:address) do |a|
                span a.address_line1.to_s
                br a.address_line2.to_s
              end
              column :city
              column :state
              column :country
              column :zip_code
            end
          end
        end
      end

      tab :orders do
        columns(class: "mb-3 g-3") do
          column(span: 6) do
            panel t(:total_orders, scope: "admin.users.panels"), class: "mb-0" do
              h3 resource.orders.completed.count
            end
          end

          column(span: 6) do
            panel t(:total_price, scope: "admin.users.panels"), class: "mb-0" do
              h3 number_to_currency resource.orders.completed.sum(:total_price)
            end
          end
        end

        panel do
          div class: "table-responsive" do
            paginated_collection(user.orders.page(params[:page]).per(10), download_links: false) do
              table_for(collection) do
                column(:id, sortable: :id) do |order|
                  link_to "##{order.id}", admin_order_path(order)
                end
                column(:state) { |order| status_tag(order.state) }
                column(:checked_out_at, sortable: :checked_out_at) do |order|
                  pretty_format(order.checked_out_at)
                end
                column(:total_price) { |order| number_to_currency order.total_price }
              end
            end
          end
        end
      end
    end

    active_admin_comments
  end

  # Form
  permit_params :name, :email, :biography,
    user_addresses_attributes: %i[
      position _destroy id fullname address_line1 address_line2
      city state zip_code country
    ]

  form do |f|
    f.semantic_errors

    panel do
      f.inputs do
        columns do
          column(span: 6) { f.input :name }
          column(span: 6) { f.input :email }
        end

        f.input :biography, as: :rich_text_area
        f.has_many :user_addresses, allow_destroy: true, sortable: :position, sortable_start: 1 do |k|
          k.inputs(class: "row") do
            k.input :fullname, wrapper_html: {class: "col-lg-6"}
          end +
            k.inputs(class: "row") do
              k.input :address_line1, wrapper_html: {class: "col-lg-6"}
              k.input :address_line2, wrapper_html: {class: "col-lg-6"}
              k.input :city
              k.input :state
              k.input :zip_code
              k.input :country
            end
        end
      end
      f.actions
    end
  end
end
