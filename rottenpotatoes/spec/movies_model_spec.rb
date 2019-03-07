require 'rails_helper'

describe Movie do
    before(:each) do
        @m1 = Movie.create(title: 'Test1', director: 'Director 1')
        @m2 = Movie.create(title: 'Test2', director: 'Director 1')
    end
    
    it 'should find movies with the same director' do
        results = Movie.return_same_director(@m1.director)
        director_list = []
        results.each do |m|
            director_list.push(m.title)
        end
        expect(director_list).to eq(['Test1','Test2'])
    end
end