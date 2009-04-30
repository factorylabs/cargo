// ==UserScript==
// @name        cargo
// @description Hijacks story stage changed events and sends an XHR request to your local cargo server that will create a new git branch when you start a story, and tries to commit that branch when you mark it as finished.
// @include     http://www.pivotaltracker.com/projects/*
// @author      Factory Design Labs
// ==/UserScript==

GARGO_SERVER = 'http://localhost:8081';
CARGO_ASK_FIRST = true;

Cargo = {
  gm: true,
  
  initialize: function() {
    // make th script work with both GreaseKit and Greasemonkey
    if (typeof(unsafeWindow) == 'undefined') {
      this.gm = false;
      window.unsafeWindow = window;
    }
    this.hijackActions();
  },
  
  hijackActions: function() {
    unsafeWindow.Cargo = this;
    var takeOverFunction = function() {
      PerformStoryAction.prototype.signalSuccessFromServer =
      PerformStoryAction.prototype.signalSuccessFromServer.wrap(
        function(oldMethod) {
          Cargo.performedStoryAction(this.story);
          oldMethod();
        }
      );
    }
    
    if (this.gm) location.href = "javascript:(" + takeOverFunction + ")()";
    else takeOverFunction();
  },
  
  performedStoryAction: function(story) {
    var state = story.getCurrentState()

    var params = {
      id: story.getId(),
      initials: (story.getOwnedBy()) ? story.getOwnedBy().initials : '',
      name: story.getName(),
      story_type: story.getStoryType()._displayName,
      description: story.getDescription()
    }

    switch (state.toString()) {
    case 'started':
      if ((CARGO_ASK_FIRST) ? confirm("Create a working branch?") : true) {
        this.request('start', params);
      }
      break;
    case 'finished':
      if ((CARGO_ASK_FIRST) ? confirm("Commit your working branch?") : true) {
        this.request('finish', params);
      }
      break;
    }
  },

  request: function(action, params) {
    setTimeout(function() {
      var method = 'POST';
      var url = [GARGO_SERVER, action].join('/');
      var headers = { 'Content-Type': 'application/x-www-form-urlencoded' };
      var data = unsafeWindow.Object.toQueryString(params);
      
      if (Cargo.gm) {
        GM_xmlhttpRequest({method: method, headers: headers, url: url, data: data,
          onerror: function() { alert("Error: Cargo server isn't started?"); },
          onload: function(response) {
            Cargo.debug(response);
          }
        });
      } else {
        new Ajax.Request(url, {method: method, parameters: params,
          onFailure: function() { alert("Error: Cargo server isn't started?"); },
          onSuccess: function(response) {
            Cargo.debug(response);
          }
        });
      }
    }, 0);
  },
  
  debug: function() {
    if (unsafeWindow.console && unsafeWindow.console.info) unsafeWindow.console.info(arguments);
  }
};

Cargo.initialize();