Installation
============

For installation use [GNU Stow](https://www.gnu.org/software/stow/). It's excellent for managing symlinks from the
dotfile folder to the real location of the dotfiles.

For a tutorial how to use Stow have a look at this [blog entry](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html) from Brandon Invergo.

Or have a look at this [video](https://www.youtube.com/watch?v=zhdO46oqeRw).

vim Plugins
-----------

The vim plugins I'm using aren't shiped with my dotfiles. You first have to install the vim plugin manager
[Plug](https://github.com/junegunn/vim-plug) which I'm using. Then you can install the plugins via
```viml
:PlugInstall
```
For more Information how you can use and install plugins with plug see its [github page](https://github.com/junegunn/vim-plug#usage).
