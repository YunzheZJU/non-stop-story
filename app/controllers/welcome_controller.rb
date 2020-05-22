# frozen_string_literal: true

class WelcomeController < ApplicationController
  def index
    render plain: 'Welcome to Holo.dev. ' \
                  'You can find many VTuber tools and developer friends here.'
  end
end
