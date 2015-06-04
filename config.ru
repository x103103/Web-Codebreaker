require './app/controllers/game_controller'

use Rack::Static, :urls => %w(/app/assets /app/views)
use Rack::Session::Cookie, :key => 'rack.session',
    :secret => 'something secret should be here'

run GameController.new