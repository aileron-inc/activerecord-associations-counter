RSpec.describe ActiveRecord::AssociationsCounter do
  describe '#decorate_count' do
    context 'When the target records exist' do
      before do
        3.times do |i|
          tweet = Tweet.create
          i.times do
            favorite = Favorite.create(tweet: tweet)
          end
        end
      end

      after do
        Tweet.delete_all
        Favorite.delete_all
      end

      it 'precounts has_many count properly' do
        expected = Tweet.all.map { |t| t.favorites.count }
        expect(
          Tweet.all.decorate_count.map(&:favorites_count)
        ).to eq(expected)
      end
    end

    context "When the target records don't exist" do
      after do
        Tweet.delete_all
        Favorite.delete_all
      end

      it 'returns empty array' do
        expect(
          Tweet.all.decorate_count
        ).to eq([])
      end
    end
  end
end
