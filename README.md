# zgen cookbook

Brain-dead simple, chef-based install of zsh, [zgen](https://github.com/tarjoilija/zgen) and a customized
zshrc. The starting incarnation of this is focused on use with 
[kitchenplan](https://github.com/kitchenplan/kitchenplan), specifically for pulling down pieces of
my newly modular [dotfiles](https://github.com/bkono/dotfiles) (2.0).

If you haven't worked with zgen before, you should definitely check it out. Its a great way to
cherry-pick your way into an excellent shell setup, without the standard single dotfiles repo
approach.

## Usage

_This section is under rapid development. Don't be disappointed when things have significantly
deviated from this readme._

Currently there is a single, default recipe. It utilizes several attributes, listed later in the
readme, to install zsh, chsh to zsh, install zgen, and create a zshrc for a set of known users. It is 
intended to be included in standard chef form:

#### Recipes

```ruby
include 'zgen::default'
```

#### Roles

```ruby
"run_list": {
  "recipe[zgen::default]"
}
```

#### Attributes

There are a few attributes that the default recipe makes use of. They will be discussed in detail
via standard table format shortly. For reference, they are node['current_user'] and
node['zgen']['users'] for getting an array of usernames to setup zsh & zgen for. Additionally, the
entries node['zgen']['oh-my-zsh'] and node['zgen']['load'] are arrays of strings listing modules to
source from either [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) or an arbitrary github
repo. More to come on this section.


## Credits

This cookbook is heavily influenced by
[cookbook-zshell](https://github.com/cassianoleal/cookbook-zshell).

And of course, this wouldn't exist without [zgen](https://github.com/tarjoilija/zgen) itself.
