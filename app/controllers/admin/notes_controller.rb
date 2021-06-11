module Admin
  class NotesController < ApplicationController
    before_action :logged_in?

    def new
      @note           = Note.new
      @contact_id     = params[:contact_id]
      @resolved_by_id = current_user.id

      respond_to do |format|
        format.html
      end
    end

    def create
      @note = Note.create(note_params)

      if @note.save
        redirect_to edit_admin_contact_path(@note.contact_id)
      else
        format.html { render action: 'new' }
      end
    end

    def destroy
      @note             = Note.find(params[:id])
      @note.resolved_at = DateTime.now
      @note.save

      respond_to do |format|
        format.html { redirect_to edit_admin_contact_path(@note.contact_id) }
      end
    end

    private

    def note_params
      params.require(:note).permit(:contact_id, :resolved_by_id, :body)
    end
  end
end
