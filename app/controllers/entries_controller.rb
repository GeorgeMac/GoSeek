class EntriesController < ApplicationController
	def new
	end

    def create
        render text: "Happy Place: " + params[:entry].inspect
    end
end
