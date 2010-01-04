class UploadsController < ApplicationController

  load_and_authorize_resource

  layout 'wide'

  def index
    @information = Upload.find_by_name('information')
    @backup = Upload.find_by_name('db_backup')
  end

  def edit
  end

  def update
    if @upload.update_attributes(params[:upload])
      if params[:restore].nil?
        flash[:notice] = 'Upload was successfully updated.'
        redirect_to(uploads_path)
      else
        redirect_to(restore_uploads_path)
      end
    else
      render :action => "edit"
    end
  end

  def restore
    Upload.restore_database(Upload.find_by_name('db_backup').upload.path)
    flash[:notice] = 'Database restored!'
    redirect_to(uploads_path)
  end

  def backup
    @backup = Upload.find_by_name('db_backup')
    File.open(@backup.upload.path, 'w'){ |f| f.write(Upload.dump_database)}
    redirect_to(transfer_upload_path(@backup))
  end

  def transfer
    return send_file(@upload.upload.path, :type => @upload.upload_content_type)
  end

end
