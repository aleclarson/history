
isDev = require "isDev"
Event = require "eve"
Type = require "Type"

{history, location, sessionStorage} = window

type = Type "History"

type.defineValues ->

  didPush: Event()

  didPop: Event()

type.definePrototype

  path:
    get: -> @_path
    set: (path) ->

      unless path.startsWith "/"
        path = "/" + path

      if isDev and path is @_path
        throw Error "Cannot set 'path' to its current value!"

      @_path = path
      history.replaceState {id: @_length}, null, path
      return

  length:
    get: -> @_length
    set: (length) ->
      if length < @_length
        if length < 0
        then history.go 0 - @_length
        else history.go length - @_length
      return

type.defineMethods

  push: (path) ->

    unless path.startsWith "/"
      path = "/" + path

    if isDev and path is @_path
      throw Error "Cannot call 'push' with the current path!"

    @_path = path
    @_updateLength length = @_length + 1
    history.pushState {id: length}, null, path

    @didPush.emit path
    return

  pop: ->
    if @_length > 0
      history.back()
    return

#
# Internal
#

type.defineValues ->

  _path: location.pathname

  _length: @_loadLength()

type.initInstance ->
  window.addEventListener "popstate", @_stateChanged.bind this
  return

type.defineMethods

  _loadLength: ->
    if length = sessionStorage.getItem "history.length"
    then parseInt length
    else 0

  _updateLength: (length) ->
    @_length = length
    sessionStorage.setItem "history.length", String length
    return

  _stateChanged: ({ state }) ->

    path = location.pathname
    return if path is @_path
    @_path = path

    if state is null
      @_updateLength 0
      @didPop.emit path
      return

    if state.id > @_length
      @_updateLength state.id
      @didPush.emit path
      return

    @_updateLength state.id
    @didPop.emit path
    return

module.exports = type.construct()
