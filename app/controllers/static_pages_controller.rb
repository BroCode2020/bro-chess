class StaticPagesController < ApplicationController

	def index
    @games = Game.all
    @game = Game.all
  end



end
