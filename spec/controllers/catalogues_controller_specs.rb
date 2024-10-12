require 'rails_helper'

RSpec.describe CataloguesController, type: :controller do
  let!(:category) { create(:category) }
  let!(:sub_category) { create(:sub_category) }
  let!(:catalogue) { create(:catalogue, category: category, sub_category: sub_category) }
  let!(:catalogue_variant) { create(:catalogue_variant, catalogue: catalogue) }
  let!(:catalogue_variant_color) { create(:catalogue_variant_color) }
  let!(:catalogue_variant_size) { create(:catalogue_variant_size) }   

  describe 'GET #index' do
    context 'when catalogues are present' do
      it 'returns a paginated list of catalogues' do
        get :index
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['catalogues']).not_to be_empty
      end
    end

    context 'when no catalogues are found' do
      it 'returns a not found status' do
        allow(Catalogue).to receive(:all).and_return(Catalogue.none)
        get :index
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq("No catalogues found")
      end
    end
  end

  describe 'GET #search' do
    it 'returns catalogues matching the search query' do
      get :search, params: { q: catalogue.name }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to be_empty
    end

    it 'returns catalogues sorted by given attribute' do
      get :search, params: { sort_by: 'name' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to be_empty
    end

    it 'filters catalogues by gender' do
      get :search, params: { gender: 'male' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).not_to be_empty
    end

    it 'returns a message if no catalogue is found' do
      get :search, params: { q: 'nonexistent' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('catalouge not found')
    end
  end

  describe 'POST #create' do



  let(:valid_attributes) do
    {
      catalogue: {
        name: "Test Catalogue",
        description: "This is a test catalogue",
        gender: "male",
        category_id: category.id,               
        sub_category_id: sub_category.id,       
        catalogue_variants_attributes: [
          {
            price: 10.99,
            catalogue_variant_color_id: catalogue_variant_color.id,  
            catalogue_variant_size_id: catalogue_variant_size.id,  
            quantity: 10
          }
        ]
      }
    }
  end

    let(:invalid_attributes) do
      { catalogue: { name: '', description: '', gender: '', category_id: '', sub_category_id: '' } }
    end

    context 'with valid parameters' do
	  it 'creates a new Catalogue' do
	    expect {
	      post :create, params: valid_attributes
	    }.to change(Catalogue, :count).by(1)

	    expect(response).to have_http_status(:created)
	  end
    end

    context 'with invalid parameters' do
      it 'does not create a Catalogue and returns errors' do
        post :create, params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).not_to be_empty
      end
    end
  end
end
