# Live Server

Idk if this is gunna work...

### UPDATE: 7/26/25

Limited functionality but it currently sends html, css, and js via local host
to the browser from this directory.

Now to figure out how to make it a nvim plugin so that I can bind this to a command
and have it attach to the project directory it was called from.

### UPDATE: 7/27/25

Found out about a built in vim function that does tcp connections so built
the script using that and was able to make it callable in nvim.

It also works from the project directory that nvim was opened in.

Just need to figure out how to get the live reload to work and we're done.
