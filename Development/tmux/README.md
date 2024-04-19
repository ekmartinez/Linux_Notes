# Tmux - Terminal Multiplexer 

Keybindings & configurations

## Attaching - Detaching

Start new tmux session:

```bash
tmux
```

List sessions:

```bash
tmux ls
```

Attach to session:

```bash
tmux attach -t <session>
```

or 

```bash
tmux a -t <session>
```

Detach session: `Ctrl + b then d`

Exit and quit tmux: `Ctrl + b then &`

List all keybindings: `Ctrl + b then ?`

## Window Management

Create new window: `Ctrl + b then c`

Move to next window: `Ctrl + b then n`

Move to previous window: `Ctrl + b then p`

Move to window by index: `Ctrl + b then 0-9`

## Pane Management

Split Horizontally: `Ctrl + b then "`

Split Vertically: `Ctrl + b then %`

Switching panes: `Ctrl + b then <arrow key>`

Resizing panes: `Ctrl +  b then Ctrl <arrow key>`

Display window index number: `Ctrl +  b then q`

## Sesssion Management

Move to next session: `Ctrl +  b then )`

Move to previous session: `Ctrl +  b then (`

Suspend session: `Ctrl + b then Ctrl + z`

## Commands

Access command prompt: `Ctrl + b then :`

Synchronize panes: `Ctrl + b then :setw synchronize-panes on`



