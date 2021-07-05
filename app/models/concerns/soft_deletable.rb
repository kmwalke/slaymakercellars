module SoftDeletable
  extend ActiveSupport::Concern

  def destroy
    if deleted_at.present?
      super
      'destroyed'
    else
      update(deleted_at: DateTime.now)
      'archived'
    end
  end

  def undestroy
    update(deleted_at: nil)
  end
end
