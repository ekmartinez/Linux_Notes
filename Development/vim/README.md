# Vim

This section contains some of the most used key bindings in vim.  There is a lot more that we can mention here and we will be adding more instructions in the future.

**Modes** 

Normal mode: `ESC`

Insert mode: `CTRL + I`   

Visual insert Mode: `SHIFT + I`

Visual block: `CTRL + V`

Command mode: `SHIFT + :`

**Keybindings**

Move left = `h`

Move right = `l`

Move up = `k`

Move down = `j`

Move top of file: `gg`

Move to bottom of file: `G`

**Cut, copy, paste**

Cut line: `dd` 

copy line: 'yy'

Paste: `p`

**Searching**

Enter command mode `SHIFT + :`

Search: `/s/pattern`

Substitute 1st instance: `/s/pattern/substitute` 

Substitute all instances: `/s/pattern/substitute/g`

**Commenting Block of Code**

Move to first line of the block of code that you want to comment, the go into Visual Block mode (CTRL+V) using navigations key to highlight the block to be commented, now use Shift to go into Insert mode (SHIFT + I), go back to the first line and inser the comment charachter "#", press ESC.

Key representation: `CTRL + V > j | k > SHIFT + I > "#" > ESC` 
