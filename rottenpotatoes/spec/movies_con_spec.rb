require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
    before(:each) do
        @m1 = Movie.create(title: "Not Alien", rating: "PG", director: "David Iyer")
        @m2 = Movie.create(title: "Alien 2", rating: "PG", director: "John")
        @m3 = Movie.create(title: "Alien 3", rating: "PG", director: "John")
        @m4 = Movie.create(title: "Alien 4", rating: "PG")
        @m5 = Movie.create(title: "Alien", director: "", rating: 'PG')
    end
    
    #get methods
    it "searches movies from the same director" do
        get :same_director,  id: @m3.id
        expect(Movie.where(:director => @m3.director).size).to eq(2)
    end
    
    it "handle when no director is present" do
        get :same_director,  id: @m4.id
        expect(flash[:notice]).to be_present
        expect(flash[:notice]).to match(/has no director info*/)
        expect(response).to redirect_to(movies_path)
    end
  
    it "renders index" do
        get :index
        response.should render_template :index
    end
    
    it "renders show details" do
        get :show, id: @m1.id
        response.should render_template :show, id: @m1.id
    end
   
    #post methods
    it 'creates a movie' do
        post :create, :movie => { :title => "Alien", :director => "Ridley Scott", :rating => 'PG' }
        expect(flash[:notice]).to be_present
        expect(response).to redirect_to(movies_path)
    end
    
    it 'edits a movie' do
        post :edit, id: @m2.id
       response.should render_template :edit, id: @m2.id
    end
    
    it 'deletes a movie' do
        @movie = Movie.create(:title => "Alien", :director => "Ridley Scott", :rating => 'PG')
        @movie.destroy
        expect{Movie.find(@movie.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
    
    #put method / update - check for updating director etc
    let(:attr) do 
        { :title => "Alien", :director => "Ridley Scott", :rating => 'R' }
    end

    before(:each) do
        put :update, :id => @m5.id, :movie => attr
        @m5.reload
    end

    it { response.should redirect_to(@m5) }
    it { @m5.title.should eql attr[:title] }
    it { @m5.director.should eql attr[:director] }
    it { @m5.rating.should eql attr[:rating] }
end