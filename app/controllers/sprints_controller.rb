#require 'stree'
class SprintsController < ApplicationController
  # current_user is defined in applicaiton
  def index
    @q = Sprint.ransack(params[:q])
    sprints = @q.result(distinct: true)
    @sprints = sprints.select {|s| s.user_id == @current_user.id}
  end
  def new
# @sprints = Sprint.all
    @sprints = Sprint.where(user_id: @current_user.id)
  end
	def create
    @sprints = Sprint.where(user_id: @current_user.id)
    repeat = params[:temp][:repeat]
    @sprint = Sprint.new(params[:sprint])
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
      some_success = my_sprints.map { |t| t.save }
      success = some_success.all?
    end
    if success
      flash[:notice] = "#{@sprint.name} was successfully created."
      redirect_to sprints_path
    else
      flash[:warning] = "It wasn't created. Can't repeat on #{repeat} while it starts #{ @sprint.start.wday }"
      render 'new' # note, 'new' template can access @sprint's field values!
    end
	end
	def edit
		@sprint = Sprint.find params[:id]
    @sprints = Sprint.where(user_id: @current_user.id)
	end
  def update
    @sprint = Sprint.find params[:id]
    @sprint.update_attributes! params[:sprint]
    @sprints = Sprint.where(user_id: @current_user.id)
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
    @sprints = Sprint.where(user_id: @current_user.id)
    if @sprints.count == 0
      flash[:notice] = 'No sprints to see. Create your umtimate goal first!'
      redirect_to sprints_path
      return
    end
    init_sprint = @sprints[0]
    root = Stree.new(init_sprint)
    @sprints[1..@sprints.size].each { |t|
      root.add(t)
    }
    @stree = root.to_json
  end
end
