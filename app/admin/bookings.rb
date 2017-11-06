ActiveAdmin.register Booking do
  menu priority: 6
  sidebar :versionate, :partial => "layouts/version", :only => :show

  member_action :history do
    @post = Post.find(params[:id])
    # @versions = @post.versions # <-- Sadly, versions aren't available in this scope, so use:
    @versions = PaperTrail::Version.where(item_type: 'Post', item_id: @post.id)
    render "layouts/history"
  end

  controller do
    def show
      @booking = Booking.includes(versions: :item).find(params[:id])
      @versions = @booking.versions
      @booking = @booking.versions[params[:version].to_i].reify if params[:version]
      show!
     end
  end
end
