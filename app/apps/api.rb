# encoding: utf-8

module OpenCode
  class API < Sinatra::Base
    use Rack::JSONP
    helpers Sinatra::JSON

    configure do
      set :json_encoder, MultiJson
    end

    configure :development do
      register Sinatra::Reloader
    end

    helpers do
      def bail(error_message=nil)
        halt 404, { :error => error_message || "Oops." }.to_json
      end

      def render_edition(edition)
        json edition.as_json.merge(:talks => edition.talks.map(&:as_json))
      end
    end

    before do
      response.headers['Access-Control-Allow-Origin'] = "*"
      response.headers['Access-Control-Allow-Methods'] = 'GET'
      response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With, Content-Type, Authorization'
    end

    options "*" do
    end

    get "/" do
      json :endpoints => [
        "/editions",
        "/editions/<edition_id>",
        "/editions/<edition_id>/talks/<talk_id>",
        "/editions/current",
        "/speakers",
        "/speakers/<speaker_id>",
        "/speakers/<speaker_id>/talks"
      ]
    end

    get "/editions" do
      @editions = Edition.all
      json @editions.map(&:as_json)
    end

    get "/editions/current" do
      @edition = Edition.all.last
      render_edition(@edition)
    end

    get "/editions/:id" do
      @edition = Edition.find(params[:id].to_i)
      bail "Unknown edition" unless @edition
      render_edition(@edition)
    end

    get "/editions/:edition_id/talks/:id" do
      @talk = Talk.find(params[:id])
      bail "Unknown talk" unless @talk and @talk.edition_id == params[:edition_id].to_i
      json @talk.as_json
    end

    get "/speakers" do
      @speakers = Speaker.all
      json @speakers.map(&:as_json)
    end

    get "/speakers/:id" do
      @speaker = Speaker.find(params[:id].to_i)
      bail "Unknown speaker" unless @speaker
      json @speaker.as_json
    end

    get "/speakers/:id/talks" do
      @speaker = Speaker.find(params[:id].to_i)
      bail "Unknown speaker" unless @speaker
      json @speaker.talks.map(&:as_json)
    end
  end
end
