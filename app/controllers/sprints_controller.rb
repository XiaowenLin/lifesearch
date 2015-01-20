#require 'stree'
class SprintsController < ApplicationController
  def index
    @sprints = Sprint.all
  end
  def new
    @sprints = Sprint.all
  end
	def create
		@sprint = Sprint.new(params[:sprint])
    @sprints = Sprint.all
		if @sprint.save
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
