require 'spec_helper'

describe Movie do
  describe 'searching for similar directors' do
    it 'should call movie with director' do
      Movie.should_receive(:similar_directors).with('THX-1138')
      Movie.similar_directors('THX-1138')
    end
  end
end
