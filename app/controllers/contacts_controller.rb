class ContactsController < ApplicationController
  before_filter :authenticate
  authorize_actions_for Contact
  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.scoped

    if params[:account_id].present?
      @contacts = @contacts.where(:account_id => params[:account_id])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.json
  def new
    @contact = Contact.new
    @contact.address = @contact.build_address
    modal = params[:modal]

    if !params[:id].blank?
      @contact.account_id = params[:id]
    end

    @contact.active = true

    respond_to do |format|
      format.html { render modal ? '_form' : 'new', :layout => modal ? 'modal' : 'application' }
      format.json { render json: @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
    @address = @contact.address || Address.new
    modal = params[:modal]
    respond_to do |format|
      format.html { render modal ? '_form' : 'edit', :layout => modal ? 'modal' : 'application' }
    end
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(params[:contact])
    @contact.active = true

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    @contact = Contact.find(params[:id])
    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to contacts_url, notice: 'Contact was successfully updated.' }
        format.json { head :no_content }
      else
        @contact.errors.each do |type,msg|
          flash[:error] = "Error: #{type}: #{msg}"
        end
        format.html { render action: "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    @id = params[:id]
    @invoices = Invoice.find(:all, :conditions => ["primary_contact_id = ?", @id])
    @invoices.each do |h| 
      h.primary_contact_id = nil
      h.save
    end

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end
end
