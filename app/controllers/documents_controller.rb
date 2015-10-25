class DocumentsController < ApplicationController
  #before_action :authenticate_user!
  #after_action :verify_authorized, except: [:index, :datatables_index, :datatables_index_exam]


  include  ActionView::Helpers::NumberHelper

  def show
    @document = Document.find(params[:id])
    file = @document.fileattach.read

    send_data file, 
      filename: @document.fileattach_filename,
      type: @document.fileattach_content_type, 
      disposition: "attachment"              
  end

  def create
    @document = @documentable.documents.new(document_params)

    respond_to do |format|
      if @document.save
        format.html { redirect_to :back, notice: t('activerecord.messages.successfull.attach_file', parent: @document.documentable.fullname, 
          child: "#{@document.fileattach_filename} (#{number_to_human_size(@document.fileattach_size)})") }
      else
        format.html { redirect_to :back, alert: t('activerecord.messages.error.attach_file', parent: @document.documentable.fullname, 
          child: "#{@document.fileattach_filename} (#{number_to_human_size(@document.fileattach_size)})") }
      end
    end
  end

  def destroy
    @document = Document.find(params[:id])
    if @document.destroy
      redirect_to :back, notice: t('activerecord.messages.successfull.remove_attach_file', parent: @document.documentable.fullname, child: @document.fileattach_filename)
    else 
      redirect_to :back, alert: t('activerecord.messages.error.destroyed', data: @document.fileattach_filename)        
    end      
  end

  private

    def document_params
      params.require(:document).permit(:fileattach, :remote_fileattach_url, :remove_fileattach)
    end

end