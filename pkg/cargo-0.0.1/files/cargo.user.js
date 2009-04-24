// ==UserScript==
// @name        cargo
// @namespace   http://fluidapp.com
// @description Attaches observers to all start/finish buttons and sends an XHR request to your local cargo server that will create a new git branch when you start a story, and tries to commits that branch when you mark it as finished.
// @include     *
// @author      Factory Design Labs
// ==/UserScript==

GARGO_SERVER = 'http://localhost:8081';

Cargo = {
  cargoFrame: null,
  
  initialize: function() {
    var testButton = new Element('div', {style: 'border: 1px solid red;position:absolute;z-index:200;top:10px;left:340px;height:20px;'}).update('test');
    document.body.appendChild(testButton);
    testButton.observe('click', function() {
      Cargo.request('start', 1);
    });
  },

  observeButtons: function(className) {
    $$('.stateChangeButton').each(function(button) {
      Event.observe(button, 'click', Cargo.buttonClicked.bindAsEventListener(this));
    });
  },

  buttonClicked: function(event) {
    var button = Event.element(event);
    if (!button.src) return;
    var id = parseInt(button.id.match(/\d+_/));
    if (button.src.indexOf('start') >= 0) {
      Cargo.startStory(id);
    } else if (button.src.indexOf('finish') >= 0) {
      Cargo.finishStory(id);
    }
  },

  startStory: function(id) {
    Cargo.request('start', id);
  },

  finishStory: function(id) {
    Cargo.request('finish', id);
  },
  
  request: function(action, id) {
    alert([action, id]);
    new Ajax.Request([GARGO_SERVER, action].join('/'), {
      parameters: {id: id},
      method: 'get',
      onSuccess: function(transport) {
        alert('testing');
        alert(transport.responseText);
      }
    });
  },
  
  notify: function(message) {
    
  }
};

Cargo.initialize();
