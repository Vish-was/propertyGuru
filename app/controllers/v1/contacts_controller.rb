module V1
  class ContactsController < ApplicationController
    before_action :authenticate_user!, only: %I[create update destroy]
    before_action :check_role, only: %I[create update destroy]

    before_action :set_base_object, only: %I[index create]
    before_action :set_contact, only: %I[show update destroy]

    # GET /divisions/:division_id/contacts
    # GEt /builders/:builder_id/contacts
    def index
      @paged = @base_object.contacts.paged(params)
    end

    # GET /contacts/:id
    def show
      @contact
    end

    # POST /builders/:builder_id/contacts
    def create
      @contact = @base_object.contacts.new(contact_params)
      if @contact.save
        json_response(@contact, :created)
      else
        json_response_error(@contact.errors.full_messages)
      end
    end

    # PUT /contacts/:id
    def update
      if @contact.update(contact_params)
        json_response(@contact, :ok)
      else
        json_response_error(@contact.errors.full_messages)
      end
    end

    # DELETE /contacts/:id
    def destroy
      if @contact.destroy
        head :no_content
      else
        head 422
      end
    end

    private

    def contact_params
      params.permit(:name, :email, :phone, :title, :division_id)
    end

    def set_base_object
      @base_object = if params[:division_id]
        Division.find(params[:division_id])
      else
        Builder.find(params[:builder_id])
      end
    end

    def set_contact
      @contact = Contact.find_by!(id: params[:id])
    end
  end
end
