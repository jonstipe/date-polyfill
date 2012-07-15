# Date polyfill

This is a polyfill for implementing the HTML5 `<input type="date">` element in browsers that do not currently support it.

## Usage

Using it is easy — simply include the `date-polyfill.js` file in the HEAD of the HTML page.  
You can then use `<input type="date">` elements normally.

If the script detects that the browser doesn't support `<input type="date">`, it will search for these elements and replace them with a jQuery UI datepicker to select the date. The date selection is stored in a hidden form field and submitted with the form in the standard format.

A default CSS file is provided. You may edit this file to style the input fields to make them look the way you want.

## Dependencies

This script requires jQuery[http://jquery.com/], jQuery UI[http://jqueryui.com/], and Modernizr[http://www.modernizr.com/].

## See also

[Compatibility chart for input datetime elements](http://caniuse.com/input-datetime)

* datetime-local-polyfill[https://github.com/jonstipe/datetime-local-polyfill]
* datetime-polyfill[https://github.com/jonstipe/datetime-polyfill]
* time-polyfill[https://github.com/jonstipe/time-polyfill]

## License (MIT)
Copyright (c) 2012 Jonathan Stipe

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

