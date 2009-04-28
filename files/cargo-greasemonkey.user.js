// ==UserScript==
// @name        cargo
// @namespace   http://fluidapp.com
// @description Hijacks story stage changed events and sends an XHR request to your local cargo server that will create a new git branch when you start a story, and tries to commit that branch when you mark it as finished.
// @include     http://www.pivotaltracker.com/projects/*
// @author      Factory Design Labs
// ==/UserScript==

GARGO_SERVER = 'http://localhost:8081';

Cargo = {
  initialize: function() {
    unsafeWindow.Cargo = this;

    this.hijackActions();
  },
  
  hijackActions: function() {
    location.href = "javascript:(" + function() {
      Story.prototype.setCurrentState = Story.prototype.setCurrentState.wrap(
        function(oldMethod, newState, disableNotify) {
          if (newState == this._currentState) return;
          oldMethod(newState, disableNotify);
          Cargo.storyStateChanged(newState, this);
        }
      );
    } + ")()";
  },
  
  storyStateChanged: function(state, story) {
    var params = {
      id: story.getId(),
      initials: story.getOwnedBy().initials,
      name: story.getName(),
      story_type: story.getStoryType()._displayName,
      description: story.getDescription()
    }

    switch (state.toString()) {
    case 'started':
      this.request('start', params);
      break;
    case 'finished':
      this.request('finish', params);
      break;
    }
  },

  request: function(action, params) {
    setTimeout(function() {
      GM_xmlhttpRequest({
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        url: [GARGO_SERVER, action].join('/'),
        data: unsafeWindow.Object.toQueryString(params),
        onload: function(response) {
          Cargo.debug(response);
        },
        onerror: function() { alert("Error: Cargo server isn't started?"); }
      });
    }, 0);
  },
  
  debug: function() {
    if (unsafeWindow.console && unsafeWindow.console.info) unsafeWindow.console.info(arguments);
  }
};

Cargo.initialize();