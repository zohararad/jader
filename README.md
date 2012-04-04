Jade
====

Jade.JS is most popular Node.JS templating framework. This gem gives
you ability to easily compile Jade templates at server-side (similar 
to how the Sprockets .eco engine works).

Gem supposed to be used with JST engine.

Example
-------

sample.jst.jade:

    !!!5
    head
      title Hello, #{name} :)
    body
      | Yap, it works

application.js (require runtime.js before templates):
  
    //= require jade/runtime
    //= require sample
    $('body').html(JST['sample']({name: 'Billy Bonga'}))


Limitations
-----------

Includes don't work with this implementation. A workaround is to use something like 

    = JST['include/foo']()

Credits
-------

This implementation was greatly inspired by two similar gems:

  - [ruby-haml-js](https://github.com/dnagir/ruby-haml-js)
  - [tilt-jade](https://github.com/therabidbanana/tilt-jade)
  
It was developed as a successor to tilt-jade to improve following:

  * Add debugging capabilities (slightly different build technique)
  * Support exact Jade.JS lib without modifications
  * Do not hold 3 copies of Jade.JS internally
  * Be well-covered with RSpec

Credits
-------

<img src="http://roundlake.ru/assets/logo.png" align="right" />

* Boris Staal ([@_inossidabile](http://twitter.com/#!/_inossidabile))

LICENSE
-------

It is free software, and may be redistributed under the terms of MIT license.