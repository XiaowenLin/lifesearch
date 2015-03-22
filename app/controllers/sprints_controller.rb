#require 'stree'
class SprintsController < ApplicationController
  def index
    @q = Sprint.ransack(params[:q])
    unless @current_user
      flash[:notice] = "Please login to view your information."
    else
      sprints = @q.result(distinct: true)
      @sprints = sprints.select {|s| s.user_id == @current_user.id}
    end
  end
  def new
# @sprints = Sprint.all
    if @current_user
      @sprints = Sprint.where(user_id: @current_user.id)
    else
      @sprints = []
    end
  end
	def create
    unless @current_user
      flask[:notice] = "Please login to view your informaiton"
      redirect_to sprints_path
    end
    @sprints = Sprint.find_by_user_id(@current_user.id)
    repeat = params[:temp][:repeat]
    @sprint = Sprint.new(params[:sprint])
    debugger
    @sprint.user_id = @current_user.id
    if repeat == 'Never'
      success = @sprint.save
    elsif repeat == 'Weekly'
      my_sprints = @sprint.repeat_weekly
    elsif repeat == 'TR Weekly'
      my_sprints = @sprint.repeat_tr_weekly
    elsif repeat == 'MWF Weekly'
      my_sprints = @sprint.repeat_mwf_weekly
    else
      return nil
    end
    if my_sprints
      success = my_sprints.each { |t| t.save }[0]
    end
    if success
      flash[:notice] = "#{@sprint.name} was successfully created."
      redirect_to sprints_path
    else
      flash[:warning] = "It wasn't created."
      render 'new' # note, 'new' template can access @sprint's field values!
    end
	end
	def edit
		@sprint = Sprint.find params[:id]
    @sprints = Sprint.all
	end
  def update
    @sprint = Sprint.find params[:id]
    @sprint.update_attributes! params[:sprint]
    @sprints = Sprint.all
    flash[:notice] = "#{@sprint.name} was updated."
    redirect_to sprints_path
  end
  def destroy
    @sprint = Sprint.find(params[:id])
    @sprint.destroy
    flash[:notice] = "#{@sprint.name} is deleted."
    redirect_to sprints_path
  end
  def visual
    @sprints = Sprint.all
    init_sprint = @sprints[0]
    root = Stree.new(init_sprint)
    @sprints[1..@sprints.size].each { |t|
      root.add(t)
    }
    @stree = root.to_json
  end
end
