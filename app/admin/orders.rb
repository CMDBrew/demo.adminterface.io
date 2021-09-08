ActiveAdmin.register Order do
  menu priority: 3
  actions :index, :show

  filter :total_price
  filter :checked_out_at

  scope :all, default: true
  scope :in_progress
  scope :complete

  batch_action :update_status, form: {
    checked_out_at: {as: :datetime_picker, label: "Checked out at", input_html: {value: Time.current}}
  } do |ids, inputs|
    Order.where(id: ids).update(checked_out_at: inputs[:checked_out_at])
    redirect_to collection_path(scope: params[:scope]), notice: "Successfully updated #{ids.count} order(s)"
  end

  index do
    selectable_column
    column("Order", sortable: :id) { |order| link_to "##{order.id} ", admin_order_path(order) }
    column("State", sortable: :checked_out_at) do |order|
      if order.state.eql?(Order::COMPLETE)
        status_tag("Completed on: #{pretty_format(order.checked_out_at)}", class: "badge alert-success")
      else
        status_tag(order.state, class: "badge alert-warning")
      end
    end
    column("Customer", :user, sortable: :user_id)
    column("Total", sortable: :total_price) { |order| number_to_currency order.total_price }
    actions(dropdown: true)
  end

  show do
    panel "Invoice" do
      attributes_table_for order.user do
        row("User") { auto_link order.user }
        row :email
      end

      div class: "table-responsive" do
        table_for(order.line_items) do |t|
          t.column("Product", class: "text-wrap") { |item| auto_link item.product }
          t.column("Price") { |item| number_to_currency item.price }
          tr class: "odd" do
            td "Total:", style: "text-align: right;"
            td number_to_currency(order.total_price)
          end
        end
      end
    end

    active_admin_comments
  end
end
