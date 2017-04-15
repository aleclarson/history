
# history v1.0.0

Simple browser history management.

```coffee
history = require "history"

# Navigate to a new url. The leading backslash is optional.
history.push "/test"

# Navigate to the previous url.
history.pop()

# Listen for `push` calls and when the user presses the forward button. 
listener = history.didPush (path) ->
  console.log "didPush:" + path

# Listen for `pop` calls and when the user presses the back button.
listener = history.didPop (path) ->
  console.log "didPop: " + path

# The current url.
history.path

# Change the current url (without triggering the `didPush` event).
history.path = "/example"

# The number of previous urls.
history.length

# Jump to a previous url (increasing the length is not supported).
history.length = 0
```

- Since `history.forward` does not exist, you must instead use `history.push`. The user can always press the forward button manually.

- `window.sessionStorage` is used to detect when the forward button is pressed (even after the page is refreshed).

