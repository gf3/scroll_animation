requestAnimationFrame = do ->
  window.requestAnimationFrame       ||
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame    ||
  window.oRequestAnimationFrame      ||
  window.msRequestAnimationFrame     ||
  (callback) -> window.setTimeout(callback, 1000 / 60)


SCROLL_ELEMENT = null
FT_SCROLL_ELEMENT = ->
  bak =
    des: document.documentElement.style.cssText
    bs:  document.body.style.cssText
  document.body.insertBefore((div = document.createElement('div')), document.body.firstChild)

  document.body.style.margin = document.documentElement.style.margin = '0'
  document.body.style.height = document.documentElement.style.height = 'auto'
  div.style.cssText = 'display:block;height:99999px;'

  scrollTop = document.documentElement.scrollTop
  scrollElement =
    if ++document.documentElement.scrollTop && document.documentElement.scrollTop == scrollTop + 1
      document.documentElement
    else
      document.body

  document.body.removeChild(div)
  document.documentElement.style.cssText = bak.des
  document.body.style.cssText = bak.bs

  SCROLL_ELEMENT = scrollElement

if document.body
  FT_SCROLL_ELEMENT()
else
  $ FT_SCROLL_ELEMENT

class @ScrollAnimation
  windowHeight   = NaN
  documentHeight = NaN
  lastTop        = NaN

  update = ->
    scrollTop = SCROLL_ELEMENT.scrollTop
    return if scrollTop is lastTop
    for anim in ScrollAnimation.animations
      anim?.animate(scrollTop, windowHeight, documentHeight, lastTop)
    lastTop = scrollTop

  run = ->
    requestAnimationFrame(run)
    update()

  @animations: []

  @register: (args...) ->
    if args[0] instanceof ScrollAnimation
      @animations.push(args[0])

  @remove: (instance) ->
    idx = @animations.indexOf instance
    return null if idx < 0
    @animations.splice idx, 1

  @start: ->
    ScrollAnimation.refresh()
    $(window).on("resize", ScrollAnimation.refresh)

    if Modernizr?.touch
      document.addEventListener("touchstart", update)
      document.addEventListener("touchmove", update)
      document.addEventListener("touchend", update)

    run()

  @refresh: ->
    windowHeight   = SCROLL_ELEMENT.clientHeight
    documentHeight = SCROLL_ELEMENT.scrollHeight
    lastTop        = 0

    anim.resize() for anim in ScrollAnimation.animations
    this

  STATE_IDLE = 0
  STATE_ANIMATING = 1

  constructor: ({@el, @animation, @reset, offset}) ->
    @offset = offset || -> 0
    offset = @offset(windowHeight)

    @resize(windowHeight)
    @state = STATE_IDLE

  resize: (viewportHeight) ->
    top = @el.offsetTop
    @start = top + @offset(viewportHeight)
    @height = @el.offsetHeight
    @end = @height + @start

  animate: (scrollTop, windowHeight, documentHeight, lastTop) ->
    unless (@start > scrollTop && @end < (scrollTop + windowHeight))
      if @state == STATE_ANIMATING
        @reset?()
        @state = STATE_IDLE

    @state = STATE_ANIMATING
    @animation.apply(this, Array::slice.call(arguments))
