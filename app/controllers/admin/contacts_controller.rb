module Admin
  class ContactsController < ApplicationController
    before_action :set_contact, only: [:edit, :update, :destroy]
    before_action :logged_in?

    def index
      @contacts = Contact.all
    end

    def new
      @contact = Contact.new
    end

    def edit
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
      @contact.destroy
      respond_to do |format|
        format.html { redirect_to admin_contacts_path, notice: 'Contact was successfully destroyed.' }
      end
    end

    private

    def set_contact
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(:name, :phone, :email, :contact_point, :address, :description, :deleted_at, :town_id)
    end
  end
end
