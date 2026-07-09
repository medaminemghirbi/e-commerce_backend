class Api::V1::Admin::DashboardController < Api::V1::Admin::BaseController
  def index
    render json: {
      kpis:                   kpis,
      revenue_by_month:       revenue_by_month,
      orders_by_status:       orders_by_status,
      orders_by_day:          orders_by_day,
      top_selling_products:   top_selling_products,
      top_viewed_products:    top_viewed_products,
      top_contacted_products: top_contacted_products,
      low_stock_products:     low_stock_products,
      recent_orders:          recent_orders
    }
  end

  private

  def kpis
    sold_orders = Order.where(status: %w[confirmed shipped delivered])
    {
      total_revenue:       Order.where(status: 'delivered').sum(:total).to_f,
      monthly_revenue:     Order.where(status: 'delivered', created_at: Time.current.beginning_of_month..).sum(:total).to_f,
      total_orders:        Order.count,
      pending_orders:      Order.where(status: 'pending').count,
      confirmed_orders:    sold_orders.count,
      cancelled_orders:    Order.where(status: 'cancelled').count,
      new_orders_today:    Order.where(created_at: Date.today.all_day).count,
      total_products:      Product.count,
      active_products:     Product.where(status: 'active').count,
      low_stock_count:     Product.where('stock_quantity <= 5').count,
      out_of_stock_count:  Product.where(stock_quantity: 0).count,
      total_clients:       User.where(role: 'client').count,
      total_categories:    Category.count,
      contact_requests:    ContactRequest.count,
      pending_contacts:    ContactRequest.where(status: 'pending').count
    }
  end

  def revenue_by_month
    Order.where(status: %w[confirmed shipped delivered])
         .where(created_at: 12.months.ago..)
         .group(Arel.sql("TO_CHAR(created_at AT TIME ZONE 'UTC', 'YYYY-MM')"))
         .order(Arel.sql("TO_CHAR(created_at AT TIME ZONE 'UTC', 'YYYY-MM')"))
         .sum(:total)
         .map { |month, total| { month: month, revenue: total.to_f } }
  end

  def orders_by_status
    Order.group(:status).count
  end

  def orders_by_day
    Order.where(created_at: 30.days.ago..)
         .group(Arel.sql("DATE(created_at AT TIME ZONE 'UTC')"))
         .order(Arel.sql("DATE(created_at AT TIME ZONE 'UTC')"))
         .count
         .map { |date, count| { date: date, count: count } }
  end

  def top_selling_products
    sales = Hash.new { |h, k| h[k] = { quantity: 0, revenue: 0.0 } }

    Order.where(status: %w[confirmed shipped delivered]).find_each do |order|
      Array(order.items).each do |item|
        pid = item['productId']&.to_i
        next unless pid
        sales[pid][:quantity] += item['quantity'].to_i
        sales[pid][:revenue]  += item['subtotal'].to_f
      end
    end

    top      = sales.sort_by { |_, v| -v[:quantity] }.first(10)
    products = Product.where(id: top.map(&:first)).index_by(&:id)

    top.filter_map do |pid, stats|
      product = products[pid]
      next unless product
      {
        id:            product.id,
        name:          product.name_fr,
        image:         product.images&.first,
        quantity_sold: stats[:quantity],
        revenue:       stats[:revenue].round(2)
      }
    end
  end

  def top_viewed_products
    Product.where('views_count > 0')
           .order(views_count: :desc)
           .limit(10)
           .map { |p| { id: p.id, name: p.name_fr, image: p.images&.first, views_count: p.views_count } }
  end

  def top_contacted_products
    ContactRequest.group(:product_id)
                  .order('count_all DESC')
                  .limit(8)
                  .count
                  .filter_map do |pid, count|
                    product = Product.find_by(id: pid)
                    next unless product
                    { id: product.id, name: product.name_fr, image: product.images&.first, contact_count: count }
                  end
  end

  def low_stock_products
    Product.where('stock_quantity <= 10 AND status = ?', 'active')
           .order(stock_quantity: :asc)
           .limit(10)
           .map { |p| { id: p.id, name: p.name_fr, stock_quantity: p.stock_quantity, image: p.images&.first } }
  end

  def recent_orders
    Order.order(created_at: :desc).limit(10).map do |o|
      { id: o.id, user_email: o.user_email, total: o.total.to_f, status: o.status, created_at: o.created_at }
    end
  end
end
