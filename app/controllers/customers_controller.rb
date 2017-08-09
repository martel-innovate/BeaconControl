class CustomersController < AdminController
  inherit_resources
  has_scope :with_email, as: :customer_email

  def create
    build_customer
    save_customer
  end

  def update
    edit_customer
    save_customer
  end

  def index
    index! do |format|
      format.html
      format.json do
        render json: {
          customers: CustomerDecorator.decorate_collection(apply_scopes(collection).all).map {|c| c.to_customer_json }
        }
      end
    end
  end

  def update_password
    @customer = Admin.find_by_id_and_role(params[:customer_id], 2)
    @customer.assign_attributes(password: Admin.generate_password)
    if @customer.save
      CustomDeviseMailer.resend_new_password(@customer).deliver
      render json: @customer.to_customer_json
    else
      render json: { errors: @customer.errors }, status: 422
    end
  end

  def batch_delete
    collection.destroy_all(id: params[:customer_ids])
    redirect_to customers_path
  end

  private

  def build_customer
    @customer = Admin.new(
      role: :customer,
      email: params[:email],
      username: params[:email],
      password: Admin.generate_password,
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

  def find_customer
    @customer = Admin.find_by_id_and_role(params[:id], 2)
  end

  def edit_customer
    find_customer
    build_contact
    build_address
    build_applications_customers
  end

  def save_customer
    if @customer.save
      render json: @customer.to_customer_json
    else
      render json: { errors: @customer.errors }, status: 422
    end
  end

  def build_applications_customers
    @customer.customers_applications.delete_all if params[:id]
    params[:applications].each { |i| @customer.customers_applications.build(applications_id: i) } if params[:applications]
  end

  def resource_class
    Admin.includes(:address, :customers_applications, contact: [:logo]).where(role: 2)
  end
end
