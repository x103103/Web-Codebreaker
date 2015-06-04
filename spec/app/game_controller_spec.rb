require_relative '../../app/controllers/game_controller'

describe GameController do

  context '#call' do
    before do
      request = double('request').as_null_object
      allow(Rack::Request).to receive(:new).and_return(request)
      subject.instance_variable_set(:@request, request)

      game = double('game').as_null_object
      subject.instance_variable_set(:@game, game)
    end

    after(:each) { subject.call '' }

    let(:request) { subject.instance_variable_get(:@request) }
    let(:game) { subject.instance_variable_get(:@game) }

    context 'when path "/"' do
      it 'should render template "index.html.erb"' do
        allow(request).to receive(:path).and_return('/')
        allow(request).to receive(:post?).and_return(false)
        expect(subject).to receive(:render_template).with('index.html.erb')
      end
    end

    context 'when path "/game"' do
      it 'should render json' do
        allow(request).to receive(:path).and_return('/game')
        allow(request).to receive(:session).and_return({game: game})
        allow(request).to receive(:post?).and_return(false)
        expect(subject).to receive(:render_json).with(game)
      end
    end

    context 'when path "/new_game"' do
      it 'should create new game' do
        allow(request).to receive(:path).and_return('/new_game')
        allow(request).to receive(:session).and_return({})
        allow(request).to receive(:post?).and_return(true)
        allow(JSON).to receive(:parse).and_return({user_name:'name'})
        expect(subject).to receive(:new_game).with('name')
      end
    end

    context 'when path "/destroy_game"' do
      it 'should destroy game' do
        allow(request).to receive(:path).and_return('/destroy_game')
        allow(request).to receive(:post?).and_return(false)
        expect(subject).to receive(:destroy_game).once
      end
    end

    context 'when path "/guess"' do
      it 'should call game guess' do
        allow(request).to receive(:path).and_return('/guess')
        allow(request).to receive(:session).and_return({game: game})
        allow(request).to receive(:post?).and_return(true)
        allow(JSON).to receive(:parse).and_return({user_code:'1234'})
        expect(game).to receive(:guess).with('1234')
      end
    end

    context 'when path "/hint"' do
      it 'should call game hint' do
        allow(request).to receive(:path).and_return('/hint')
        allow(request).to receive(:session).and_return({game: game})
        allow(request).to receive(:post?).and_return(false)
        expect(game).to receive(:hint)
      end
    end

    context 'when path "/scores"' do
      it 'should call Game load' do
        allow(request).to receive(:path).and_return('/scores')
        allow(request).to receive(:session).and_return({game: game})
        allow(request).to receive(:post?).and_return(false)
        expect(Codebreaker::Game).to receive(:load).and_return([]).once
      end
    end

    context 'when path "/save"' do
      it 'should call game save' do
        allow(request).to receive(:path).and_return('/save')
        allow(request).to receive(:session).and_return({game: game})
        allow(request).to receive(:post?).and_return(false)
        expect(game).to receive(:save).once
      end
    end

    context 'when wrong path' do
      it 'should return 404' do
        allow(request).to receive(:path).and_return('/fuck')
        expect(subject).to receive(:call).and_return(Rack::Response.new('Not Found', 404))
      end
    end
  end
end