class CustomersController < AdminController
  inherit_resources

  def create
    build_customer
    if @customer.save
      render json: @customer.to_customer_json
    else
      render json: { errors: @customer.errors }, status: 422
    end
  end

  def index
    index! do |format|
      format.html
      format.json do
        render json: {
          customers: collection_by_page.map {|c| c.to_customer_json },
          total_pages: collection_by_page.total_pages
        }
      end
    end
  end
  private

  def build_customer
    @customer = Admin.new(
      role: :customer,
      email: params[:email],
      username: params[:username],
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      account: current_admin.account
    )
    build_contact
    build_address
    build_applications_customers
  end

  def build_contact
    @customer.build_contact(
      name: params[:customer_name],
      phone_number: params[:phone_number],
      position: params[:position]
    )
    @customer.contact.build_logo(file: params[:logo])
  end

  def build_address
    @customer.build_address(
      street: params[:street],
      zip: params[:zip],
      city: params[:city]
    )
  end

  def build_applications_customers
    params[:applications].each { |i| @customer.customers_applications.build(applications_id: i) } if params[:application]
  end

  def resource_class
    Admin.includes(:address, contact: [:logo]).where(role: 2)
  end

  def collection_by_page
    collection.page(params[:page]).per(5) if params[:page]
  end
end
