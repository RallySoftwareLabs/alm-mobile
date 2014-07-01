var React = require('react');
var ReactTestUtils = React.addons.TestUtils;
var app = require('application');
var OwnerView = require('views/field/owner');
var UserStory = require('models/user_story');

var createOwnerView = function(owner, editMode) {
  var userStory = new UserStory();
  userStory.set('Owner', owner);
  return ReactTestUtils.renderIntoDocument(OwnerView({
    item: userStory,
    editMode: editMode,
    allowedValues: []
  }));
};

describe('views/field/owner', function() {
  it('should render in display mode', function() {
    var view = createOwnerView();
    var field = ReactTestUtils.findRenderedDOMComponentWithClass(view, 'display');

    expect(field).not.to.be.null;
  });

  it('when no owner is selected should render the select owner picto font', function() {
    var view = createOwnerView();

    var pictoFont = ReactTestUtils.findRenderedDOMComponentWithClass(view, 'picto icon-user-add');
    expect(pictoFont).not.to.be.null;
  });

  it('should publish startEdit on click', function() {
    var view = createOwnerView();
    var ownerField = ReactTestUtils.findRenderedDOMComponentWithClass(view, 'owner-field');
    var editSpy = this.spy();
    this.subscribeEvent('startEdit', editSpy);

    ReactTestUtils.Simulate.click(ownerField);

    expect(editSpy).to.have.been.called.once;
  });

  describe('when an owner is selected', function() {
    beforeEach(function() {
      this.view = createOwnerView({
        Name: 'Willbo Huggins',
        _ref: '/userstory/8675309'
      });
    });

    it('should render the owner profile image when an owner is selected', function() {
      var profileImage = ReactTestUtils.findRenderedDOMComponentWithClass(this.view, 'profile-image');        
      expect(profileImage.props.style.backgroundImage).to.contain('/profile/image/8675309');
    });

    it('should use a 160px owner image', function() {
      var profileImage = ReactTestUtils.findRenderedDOMComponentWithClass(this.view, 'profile-image');        
      expect(profileImage.props.style.backgroundImage).to.contain('160.sp');
    });
  });

  describe('when in edit mode', function() {
    beforeEach(function() {
      this.view = createOwnerView({
        Name: 'Willbo Huggins',
        _ref: '/userstory/8675309'
      }, true);
    });

    it('should render in edit mode', function() {
      var field = ReactTestUtils.findRenderedDOMComponentWithClass(this.view, 'edit');

      expect(field).not.to.be.null;
    });

    it('should render an editor for the field', function() {
      var editor = ReactTestUtils.findRenderedDOMComponentWithClass(this.view, 'editor Owner');

      expect(editor).not.to.be.null;
    });

    it('should not publish startEdit on click', function() {
      var ownerField = ReactTestUtils.findRenderedDOMComponentWithClass(this.view, 'owner-field');
      var editSpy = this.spy();
      this.subscribeEvent('startEdit', editSpy);

      ReactTestUtils.Simulate.click(ownerField);

      expect(editSpy).not.to.have.been.called;
    });
  })
});