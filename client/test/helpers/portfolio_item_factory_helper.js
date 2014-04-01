var PortfolioItemModelFactory = require('lib/portfolio_item_model_factory');
var PortfolioItems = require('collections/portfolio_items');
var PortfolioItem = require('models/portfolio_item');
beforeEach(function() {
    this.stubPIFactory = function() {
        this.featureModel = PortfolioItem.extend({
            urlRoot: 'https://rally1.rallydev.com/slm/webservice/v2.0/portfolioitem/feature',
            typePath: '/portfolioitem/feature'
        });
        this.initiativeModel = PortfolioItem.extend({
            urlRoot: 'https://rally1.rallydev.com/slm/webservice/v2.0/portfolioitem/initiative',
            typePath: '/portfolioitem/initiative'
        });
        this.featuresCollection = PortfolioItems.extend({
            url: 'https://rally1.rallydev.com/slm/webservice/v2.0/portfolioitem/feature',
            model: this.featureModel,
            typePath: '/portfolioitem/feature'
        });
        this.initiativesCollection = PortfolioItems.extend({
            url: 'https://rally1.rallydev.com/slm/webservice/v2.0/portfolioitem/initiative',
            model: this.initiativeModel,
            typePath: '/portfolioitem/initiative'
        });
        this.piModelFactoryStub = this.stub(PortfolioItemModelFactory, 'getCollection');
        this.piModelFactoryStub.withArgs(0).returns(this.promiseResolvingTo(this.featuresCollection));
        this.piModelFactoryStub.withArgs(1).returns(this.promiseResolvingTo(this.initiativesCollection));
    };
});