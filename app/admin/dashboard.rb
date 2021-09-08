ActiveAdmin.register_page "Dashboard" do
  menu priority: 1

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column(span: 6) do
        panel t(:recent_orders, scope: "admin.dashboard") do
          div class: "table-responsive" do
            table_for Admin::OrderDecorator.decorate_collection(Order.completed.order("id desc").limit(10)) do
              column(:state) { |order| status_tag(order.state, class: "badge alert-#{order.state.eql?(Order::COMPLETE) ? "success" : "warning"}") }
              column(:user)
              column(:total_price) { |order| number_to_currency order.total_price }
            end
          end
        end
      end

      column(span: 6) do
        panel t(:recent_users, scope: "admin.dashboard") do
          div class: "table-responsive" do
            table_for Admin::UserDecorator.decorate_collection(User.order("id desc").limit(10)).each do |_user|
              column(:name) { |user| link_to(user.name, admin_user_path(user)) }
            end
          end
        end
      end
    end
  end
end
