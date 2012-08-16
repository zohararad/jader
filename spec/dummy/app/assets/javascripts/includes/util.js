// This is a mock Util object
// Used for testing server-side inclusion of Javascripts
var Util = {
  ISODate: function(){
    var d = new Date()
    return d.toISOString()
  }
}