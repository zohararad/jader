// This is a mock Util object
// Used for testing server-side inclusion of Javascripts
;(function(global){

  var Util = {
    ISODate: function(){
      var d = new Date()
      return d.toISOString()
    }
  };
  // attach to global object to make it available inside jade templates with node.js
  global.Util = Util;

})(this);