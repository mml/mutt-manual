# mutt-manual tags

This tool creates a `tags` file based on a plaintext rendering of the
mutt manual.  This enables you to use vim's tag support when editing
your `.muttrc` file.

The repo includes a version of the mutt manual, but you can easily
replace it with one of your own.  See the makefile.

## Setup

To set things up, add the following to
`~/.vim/after/ftplugin/muttrc.vim`

```vim
setlocal tags=~/Projects/mutt-manual/tags
```

And also consider adding a line like this to your `vimrc`

```vim
autocmd BufNewFile,BufRead */mutt-manual/* setlocal tags=~/Projects/mutt-manual/tags
```
