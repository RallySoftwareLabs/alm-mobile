var PortfolioItemModelFactory = require('lib/portfolio_item_model_factory');
var TypeDefinitions = require('collections/type_definitions');
var TypeDefinition = require('models/type_definition');

describe('lib/portfolio_item_model_factory', function() {

  beforeEach(function() {
    PortfolioItemModelFactory.clear();
  });
  
  describe('#getCollection', function() {
    it('should build the collections correctly', function() {
      var fetchStub = this.stubCollectionFetch(
        TypeDefinitions, 'fetchAllPages', [
          {
            Ordinal: 0,
            TypePath: 'PortfolioItem/Feature',
            Name: 'Feature'
          },
          {
            Ordinal: 1,
            TypePath: 'PortfolioItem/Initiative',
            Name: 'Initiative'
          }
        ]
      );

      return PortfolioItemModelFactory.getCollection(0).then(function(featureModel) {
        expect(fetchStub).to.have.been.calledOnce;
        expect(featureModel.prototype.typePath).to.equal('PortfolioItem/Feature');
        expect(featureModel.prototype.url).to.include('portfolioitem/feature');
        expect(featureModel.prototype.name).to.equal('Feature');
        expect(featureModel.prototype.model.prototype.typePath).to.equal('PortfolioItem/Feature');
        expect(featureModel.prototype.model.prototype.urlRoot).to.include('portfolioitem/feature');
        expect(featureModel.prototype.model.prototype.name).to.equal('Feature');
      });
    });

    it('should cache results', function() {
      var fetchStub = this.stubCollectionFetch(
        TypeDefinitions, 'fetchAllPages', [
          {
            Ordinal: 0,
            TypePath: 'PortfolioItem/Feature',
            Name: 'Feature'
          },
          {
            Ordinal: 1,
            TypePath: 'PortfolioItem/Initiative',
            Name: 'Initiative'
          }
        ]
      );

      return PortfolioItemModelFactory.getCollection(0).then(function(featureModel) {
        expect(fetchStub).to.have.been.calledOnce;
        fetchStub.reset();
      }).then(function() {
        PortfolioItemModelFactory.getCollection(1).then(function(initiativeModel) {
          expect(fetchStub).not.to.have.been.called;
          expect(initiativeModel.prototype.typePath).to.equal('PortfolioItem/Initiative');
        });
      });
    });
  });
  
});