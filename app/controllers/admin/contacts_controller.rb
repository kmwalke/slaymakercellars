module Admin
  class ContactsController < ApplicationController
    before_action :set_contact, only: [:edit, :update, :destroy, :undestroy, :repeat_last_order]
    before_action :must_be_admin
    after_action :sync_to_xero, only: [:update, :create]

    def index
      @show, @contacts, @title = Contact.display(params[:show], params[:search], sort_by, sort_direction)
    end

    def new
      @contact = Contact.new
    end

    def edit
      @notes = @contact.notes.order('created_at desc')
    end

    def create
      @contact = Contact.new(contact_params)

      respond_to do |format|
        if @contact.save
          format.html { redirect_to admin_contacts_path, notice: 'Contact was successfully created.' }
        else
          format.html { render :new }
        end
      end
    end

    def update
      respond_to do |format|
        if @contact.update(contact_params)
          format.html { redirect_to admin_contacts_path, notice: 'Contact was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      notice = @contact.destroy
      respond_to do |format|
        format.html { redirect_to admin_contacts_path, notice: "Contact was successfully #{notice}." }
      end
    end

    def undestroy
      @contact.undestroy
      respond_to do |format|
        format.html { redirect_to admin_contacts_path, notice: 'Contact was made active.' }
      end
    end

    def repeat_last_order
      new_order = @contact.repeat_last_order
      new_order.update(created_by: current_user)
      redirect_to edit_admin_order_path(new_order)
    end

    private

    def set_contact
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(
        :address,
        :always_gets_case_deal,
        :contact_point,
        :deleted_at,
        :description,
        :email,
        :is_public,
        :name,
        :phone,
        :paperless_billing,
        :pickup_check,
        :town_name,
        :unit_number,
        :url
      )
    end

    def sync_to_xero
      super(@contact, Xero::Contact)
    end

    def sort_by
      return 'contacts.name' if params[:sort].blank?

      params[:sort]
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end
  end
end
