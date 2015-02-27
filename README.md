Good™ Scroll Animations
=======================

Good-as-hell scroll animations.


Usage
-----

Create your animation by specifiying the target element an animation function:

``` javascript
var animation = new ScrollAnimation({
  el: document.body,
  animation: function(scrollTop, windowHeight, documentHeight) {
    // Do stuff...
  }
});
```

And register your new animation:

``` javascript
ScrollAnimation.register(animation);
```

You can register as many animations as you like. Finally you need to tell
`ScrollAnimation` to begin, typically you'd want to do this on DOMReady or
window load:

``` javascript
ScrollAnimation.start();
```

Hell yeah!

Animations can also remove themselves so they're no longer called. You might
opt to do this once an animation is complete:

``` javascript
ScrollAnimation.remove(animation);
```


Installation
------------

### Browser

Simply include scroll_animation after jQuery:

``` html
<script src="/javascripts/scroll_animation.js"></script>
```

### Bower

``` sh
bower install scroll_animation
```
