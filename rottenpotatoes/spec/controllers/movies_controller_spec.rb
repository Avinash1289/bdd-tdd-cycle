require 'spec_helper'

describe MoviesController do
  describe 'add director info' do
    before(:each) {
      @m = double(Movie, :title => "THX-1138", :director => "Dummy Dir", :id => "4")
        Movie.stub(:find).with("4").and_return(@m)
    }
    it 'should update attributes and redirect back' do
      @m.stub(:update_attributes!).and_return(true)
      put :update, {:id => "4", :movie => @m}
      response.should redirect_to(movie_path(@m))
    end
  end

  describe 'happy path' do
  before(:each){
    @m = double(Movie, :title => "THX-1138", :director => "Dummy Dir", :id => "4")
    Movie.stub(:find).with("4").and_return(@m)
  }
  it 'should generate route for similar movies' do
    { :post => movie_similar_path(4)}.
      should route_to("movies#similar", :movie_id => "4")
  end
  it 'should render similar template and provide results' do
    Movie.stub(:similar_directors).with('Dummy Dir').and_return(@m)
    get :similar, :movie_id => "4"
    response.should render_template('similar')
    assigns(:movies).should == @m
  end
  it 'should call model method that finds similar movies' do
    mocked_results = [double('Movie'), double('Movie')]
    Movie.should_receive(:similar_directors).with('Dummy Dir').and_return(mocked_results)
    get :similar, :movie_id => "4"
  end
  end
  describe 'sad path' do
    before(:each){
    m = double(Movie, :title => "THX-1138", :director => nil, :id => "4")
    Movie.stub(:find).with("4").and_return(m)
    }
    it 'should generate route for similar movies' do
    { :post =>  movie_similar_path(4) }.
      should route_to("movies#similar", :movie_id => "4")
    end
    it 'should render the index template and generate flash message' do
      get :similar, :movie_id => "4"
      response.should redirect_to(movies_path)
      flash[:notice].should_not be_blank
    end
  end

  describe 'create and destroy movie' do
    it 'should create a movie' do
      MoviesController.stub(:create).and_return(double('Movie'))
      post :create, {:id => "4"}
    end
    it 'should destroy a movie' do
      m = double(Movie, :id => "100", :title => "Hello World", :director => nil)
      Movie.stub(:find).with("100").and_return(m)
      m.should_receive(:destroy)
      delete :destroy, {:id => "100"}
    end
  end
end
