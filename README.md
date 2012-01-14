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

License
-------

    Copyright (C) 2011 by Boris Staal <boris@roundlake.ru>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
