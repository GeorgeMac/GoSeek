class EntriesController < ApplicationController

    before_filter :authenticate_user!, only: [:new, :create, :update]

	def index
        @entries = Entry.search params
	end

	def show
        @entry = Entry.find(params[:id])
	end

	def new
	end

    def create
        @entry = Entry.new(create_params)
        @entry.save
        redirect_to @entry
    end

    def edit
        @entry = Entry.find(params[:id])
    end

    def update
        @entry = Entry.find(params[:id])
        @entry.update(update_params)
        @entry.save
        redirect_to @entry
    end

    private
    def create_params
    	entry = params.require(:entry).permit(:title,:description,:url,:user_id)
        entry.require(:title)
        entry.require(:url)
        entry.require(:user_id)
        return entry
    end

    private 
    def update_params
        params.require(:entry).permit(:title,:description,:url)
    end

end
