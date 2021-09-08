ActiveAdmin.register Order do
  menu priority: 3
  decorate_with Admin::OrderDecorator

  actions :index, :show

  filter :total_price
  filter :checked_out_at

  scope :all, default: true, show_count: false
  scope :in_progress
  scope :completed, show_count: false

  batch_action :update_status, form: {
    checked_out_at: {as: :datetime_picker, label: Order.human_attribute_name(:checked_out_at), input_html: {value: Time.current}}
  } do |ids, inputs|
    Order.where(id: ids).update(checked_out_at: inputs[:checked_out_at])
    redirect_to(collection_path(scope: params[:scope]),
      notice: t(:successfully_updated, scope: "admin.orders.batch_actions", model: Order.model_name.human(count: ids.count).downcase, count: ids.count))
  end

  index do
    selectable_column
    column(:id) { |order| link_to "##{order.id} ", admin_order_path(order) }
    column(:state, sortable: :checked_out_at) do |order|
      if order.state.eql?(Order::COMPLETE)
        status_tag(order.state,
          label: t(:completed_at, scope: "admin.orders.state", datetime: pretty_format(order.checked_out_at)),
          class: "badge alert-success")
      else
        status_tag(order.state, class: "badge alert-warning")
      end
    end
    column(:user, sortable: :user_id) { |u| u.user_avatar_with_name }
    column(:total_price) { |order| number_to_currency order.total_price }
  end

  show do
    panel t(:details, scope: "active_admin", model: Order.model_name.human) do
      attributes_table_for order.user do
        row(:user) { auto_link order.user, order.user_avatar_with_name }
        row :email
      end

      div class: "table-responsive" do
        table_for(order.line_items) do |t|
          t.column(:product, class: "text-wrap") { |item| auto_link item.product }
          t.column(:price) { |item| number_to_currency item.price }
          tr do
            td t(:total, scope: "admin.orders"), class: "text-end"
            td number_to_currency(order.total_price)
          end
        end
      end
    end

    active_admin_comments
  end
end
