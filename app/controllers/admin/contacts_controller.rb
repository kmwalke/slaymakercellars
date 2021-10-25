module Admin
  class ContactsController < ApplicationController
    before_action :set_contact, only: [:edit, :update, :destroy, :undestroy]
    before_action :logged_in?
    after_action :sync_to_xero, only: [:update, :create]

    def index
      @show, @contacts, @title = Contact.display(params[:show], params[:search])
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

    private

    def set_contact
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(
        :name,
        :phone,
        :email,
        :url,
        :contact_point,
        :address,
        :description,
        :deleted_at,
        :town_id,
        :pickup_check
      )
    end

    def sync_to_xero
      begin
        xero_id = Xero::Contact.create(current_user, @contact).id
        @contact.update(xero_id: xero_id) if @contact.xero_id.nil?
      rescue Xero::NotConnectedError => e
        log_error(current_user.name + ' ' + e.message)
      end
    end
  end
end
