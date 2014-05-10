/** @jsx React.DOM */
var React = require('react');
var Markdown = require('pagedown');
var utils = require('lib/utils');
var ReactView = require('views/base/react_view');
var FieldMixin = require('views/field/field_mixin');

module.exports = ReactView.createBackboneClass({
  mixins: [FieldMixin],
  getDefaultProps: function() {
    return {
      field: 'Description',
      label: 'Description'
    };
  },
  render: function() {
    var fieldValue = utils.fixImageSrcs(this.getFieldValue()),
        editMode = this.isEditMode();
    return (
      <div className={ editMode ? "edit" : "display" }>
        <div className="well-title control-label">
          { this.props.label} (Edit using <a href="http://daringfireball.net/projects/markdown/syntax" target="_blank">Markdown</a>)
        </div>
        <div className="well well-sm">
          { editMode ?
            <textarea className={ "editor " + this.props.field }
                      placeholder={ this.props.field }
                      defaultValue={ utils.md(fieldValue) }
                      onBlur={ this.endEdit }
                      onKeyDown={ this._onKeyDown }/>
            :
            <div className="html-field"
                 tabIndex="0"
                 dangerouslySetInnerHTML={{__html: (fieldValue || '') + '&nbsp;'}}
                 onClick={ this.startEdit }
                 role="link"
                 aria-label={ this.getFieldAriaLabel() }
                 onKeyDown={ this.handleEnterAsClick(this.startEdit) }/>
          }
        </div>
      </div>
    );
  },

  _onKeyDown: function(e) {
    if (e.key === 'Esc' || e.key === 'Escape') {
      this.onKeyDown(e);
    }
  },

  parseValue: function(value) {
    return new Markdown.Converter().makeHtml(value).replace(/(\r\n|\n|\r)/gm,"");
  }
});
