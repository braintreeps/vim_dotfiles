# Essential VIM

This guide's goal is to turn you from a vim noob into a vim wizard by knowledge dumping all the most useful tips and tricks that you should really be aware of in order to get the most out of Vim and Neovim.

The tips and tricks in this guide will be transferrable across any Vim or Neovim configuration! We're not talking about plugins or Braintree specific customizations here!

Without further ado, lets start with the most important concept in Vim - Modal Editing

## What is a Modal Editor?

In a nutshell, a modal editor is called that because it has different "modes" where it behaves differently.

Hitting a key in one mode will not necessarily do the same thing as hitting the same key in another mode, and in Vim almost 100% of the time it won't!

Vim has a bunch of modes, but the core ones to know about are the following:

- **`NORMAL`** - The "default" mode in Vim.
  - *Most of the time you'll be running commands with operators here*
- **`INSERT`** - The "type stuff out" mode
  - *This is the mode that most resembles other "traditional editors". Type out "xyz" and "xyz" appears*
- **`VISUAL`** - The "select stuff" mode
  - *When a command with an operator won't cut it, or when you just want to do multiple things with a chunk of code, visual mode is how you can select whatever you want to select*

`INSERT` mode will be the most familiar to first time vimmers. You can get in and out with `i` and `Esc` (from `NORMAL` mode) and you can type out code the same way you would in any non-vim editor. You can basically think of other editors as being in `INSERT` mode all the time.

`VISUAL` mode is akin to clicking and dragging with your mouse to highlight some text in another non-vim editor. Once you have something visually selected, you can then run commands on that selection, the same as you would elsewhere.

`NORMAL` mode is where Vim truly shines, and almost all the awesome Vim essentials you're about to learn start here

## Vim's `INSERT` mode

Most of what you'll be doing IN insert mode is self explanatory, so this section will focus mainly on how to get there.

Coming from `NORMAL` mode (which we'll learn more about soon), you have a variety of ways to enter `INSERT` mode to be able to type out your text:

- `i` - enter `INSERT` mode (at the cursor's location)
- `a` - enter `INSERT` mode (*after* the cursor's location)
- `I` - enter `INSERT` mode (at the beginning of the line)
- `A` - enter `INSERT` mode (at the end of the line)
- `o` - enter `INSERT` mode (on a new line below)
- `O` - enter `INSERT` mode (on a new line above)
- `gi` - enter `INSERT` mode (at the location you last left it)

Each of these ways of entering `INSERT` mode has their time and place where they're most useful. All are equally important and it is recommended to practice with each!

Inside insert mode, there are a variety of special commands aside from the basic "type contents out" functionality, but these capabilities are pretty niche and can hardly be described as "essential", so we'll skip over those in this guide.

This is the only special insert mode command you need to know for now:

- `Esc` - Get out of `INSERT` mode (or any other mode, for that matter)

That's pretty much it for insert mode! Onward to the good stuff!

## Vim's `NORMAL` Mode

Vim's normal mode can do just about anything you can think of to do when it comes to text editing in just a few keystrokes.

You've probably heard about how Vim users never touch a mouse. If not, surprise! We don't even have mouse support turned on by default here at Braintree!

But don't panic, soon enough you won't need it either. It's time to learn about Vim motions!

### Vim Motions

In `NORMAL` mode, there are many different ways to move your cursor around.

#### The most basic of basics - moving the cursor one character at a time
- `h`/`j`/`k`/`l` - The basic left/down/up/right motions
- Arrow keys work too, but it's encouraged to stay on the "home row" of your keyboard

### Horizontal Motions

#### "Word-wise" horizontal motions
- `w` - move forward one "word" (contiguous characters delimited by punctuation)
- `W` - move forward one "WORD" (contiguous characters including punctuation)
- `b` - move backward one "word"
- `B` - move backward one "WORD"
- `e` - move forward to the next end of a "word"
- `E` - move forward to the next end of a "WORD"
- `ge` - move backward to the previous end of a "word"
- `gE` - move backward to the previous end of a "WORD"

#### "Char-wise" horizontal motions
- `f<char>` - go to the next `<char>` on the current line
- `F<char>` - go to the previous `<char>` on the current line
- `t<char>` - go to just before the next `<char>` on the current line
- `T<char>` - go to just after the previous `<char>` on the current line
- `;` - repeat the last char-wise motion
- `,` - repeat the last char-wise motion in the opposite direction

#### Beginnings and endings
- `0` - go to the beginning of the line
- `^` / `_` - go to the first non-whitespace character of the line
- `$` / `g_` - got to the end of the line

### Vertical Motions

#### Getting to specific lines
- `gg` - go to the first line in the file
- `G` - go to the last line in the file
- `<number>G` / `:<number>` - go to line number `<number>` (`10G` or `:10` both move the cursor to line 10)

#### Jumping up and down
- `}` - jump down to the next empty line (over a paragraph)
- `{` - jump up to the previous empty line (over a paragraph)
- `<C-d>` - jump down half a page (hold control + press `d`)
- `<C-u>` - jump up half a page (hold control + press `u`)
- `%` - Jump between matching "pairs" (jump between opening/closing `()`, `{}`, etc.)

#### Jumping to search results
- `/<search>` - Type out a string and then hit `<CR>`(enter) to jump to the next occurrence
- `?<search>` - Same as `/` but in reverse (jumps to previous occurrence)
- `*` - Populate a search with the "word" under your cursor and jump to the next occurrence
- `n` - jump to the next occurrence of your search (in the direction you started with)
- `N` - jump to the previous occurrence of your search (jumps in opposite direction)

### Motions Recap

Getting around in Normal mode with the motions listed out above might feel a bit awkward at first (especially if you're used to getting where you want to go by clicking there with your mouse), but with practice these motions will start to feel like second nature and you'll start to wonder how you ever survived without them.

But motions are just the beginning! The real magic of Normal mode isn't just how you can get around with motions, it's how you can combine them with `operators` to get things done! Let's take a look at the most important operators you'll be using in Vim.

### Core Operators

The following three operators are the most important tools in your Vim toolbox! All three of these operators make use of `registers` as well, but we'll talk more about those later

- `y` - the "yank" operator
  - *You can think of "yank" like "copy" in other editors*
- `d` - the "delete" operator
  - *You can think of "delete" like "cut" in other editors*
- `c` - the "change" operator
  - *This one is like `d`, but also drops you into insert mode*

### Creating Commands with Operators

The three operators above don't actually do anything by themselves in `NORMAL` mode. In order to use them, you will be composing them with motions to create `commands`. Here are a few examples you'll probably end up using on a daily basis:

- `ce` - change from here to the end of the current word
- `dt(` - delete from here to just before the next `(`
- `y%` - yank from here to the matching closing tag

### Caps and Double-taps

Almost every operator in Vim has a predictable "Capital" form and "Double-tap" form that act as convenient shortcuts for what would otherwise be a command made out of motions requiring additional keypresses.

The upper-case character for most operators turn the operator into a shortcut for "operate from here to the end of the line", while double-tapping operators usually makes them operate on the entire line.

- `Y` - yank from here to the end of the current line
  - *shortcut for `y$`*
- `yy` - yank this entire line (line-wise yank)
  - *shortcut for `Vy`*
- `D` - delete from here to the end of the current line
  - *shortcut for `d$`*
- `dd` - delete this entire line (line-wise delete)
  - *shortcut for `Vd`*
- `C` - change from here to the end of the current line
  - *shortcut for `c$`*
- `cc` - change this entire line (line-wise change)
  - *shortcut for `Vc`*

### What About Paste?

All three of the operators we learned about so far either "cut" or "copy" text. This next command should look pretty intuitive, but it's our first standalone command rather than an "operator". The rules around operators in Vim won't apply to this command.

- `p` - paste *after* the cursor
  - *pastes whatever you last yanked/deleted after your cursor's position*
  - *or after the current cursor's line, if the pasted content is line-wise*
- `P` - paste *before* the cursor
  - *or before the current line, if the content being pasted is line-wise*
  - note that there is no `pp` - *`p` is not an operator*

> [!TIP]
> All the commands we've learned so far use a Vim concept called `registers` under the hood. In a nutshell, a register is just a place where Vim temporarily stores some text. When you're just getting started with Vim you won't need to think about these much, but if you're curious, you can inspect your registers with `:reg`. We'll touch on these some more later

### Text Objects

Building on the basic recipe we know so far that allows us to combine `operators` with `motions` to create `commands`, operators can also be combined with `text objects`. Text objects are chunks of text within your document that the editor recognizes based on the document's structure.

Looking back at what we learned in the motions section, the "word" and "WORD" concepts that we mentioned earlier are actually two of these `text objects` that Vim is capable of recognizing. Let's take a look at a few more:

- `w` ("word") - continuous alphanumeric characters, broken by punctuation
  - *example: `hello.world` has 3 "words", `hello`, `.`, `world`. (since `.` can't be included in other "words" it becomes its own "word", as far as operators are concerned)*
- `W` ("WORD") - continuous characters (only broken by whitespace)
  - *example: `hello.world()` is only one "WORD"
- `s` ("sentence") - matches a sentence delimited by punctuation in a paragraph.
  - *mostly useful when writing stuff other than code*
- `p` ("paragraph") - matches continuous lines of text between whitespace
  - *for when you want to operate on an entire block of text with one command*
- `i` ("indentation level") - matches all lines of text at the current indentation level, whitespace included
  - *now we're cooking with oil!*

### Inside and Around

Text objects are great, and they open the door for hugely powerful commands that only take a couple keystrokes. Before we start combining operators and text objects though, we need to understand `i` (inside) and `a` (around). Every text object command requires you to specify one of these two modifiers to zero in on the exact text you're aiming for.

- `i` (inside)
  - When used with any text object, the `i` modifier allows you to target only the text that makes up the text object
  - For example, if you have your cursor on the `is` in `vim is awesome!` and hit the command `diw` (delete inside word), you'll be left with `vim  awesome`, with your cursor in between those two spaces.
  - As another example, if you put your cursor onto one of the values in the hash below and hit `yii` (yank inside indent level), you'll find yoursef copying all the key-value pairs inside `foo: { ... }`
  ```ruby
  foo: {
    bar: :bar,
    baz: :baz,
    biz: :biz,
  }
  ```
- `a` (around)
  - When used with any text object, the `a` modifier allows you to target the text object AND its immediate surroundings
  - For example, when used with the `w` ("word") text object on the example above, entering `daw` (delete around word) while your cursor is on `is` in `vim awesome!`, you'll be left with `vim awesome!` with your cursor at the beginning of `awesome`.
     - What happened here? The `a` in `daw` targeted the trailing whitespace after the targeted "word", so we end up deleting `is ` instead of just `is`
  - In the indentation example, putting your cursor on one of the values above and hitting `yai` will yank not only the values, but also the two enclosing lines for the hash at the current indentation level!

Getting comfortable combining text objects with commands using their `a` and `i` variants is critical to get the most out of Vim! Start using these tricks daily and soon you'll find yourself withing you could use them anywhere, even outside of Vim!

### All Together Now! - Common Vim Text Object Commands

- `dap` - Delete an entire block (and one of its surrounding new lines)
- `dii` - Delete everything at the current indentation level
- `ciW` - Change the entire current "WORD" under the cursor
- `yi{` - Yank everything inside the current enclosing `{}`
- `ya(` - Yank everything inside the current enclosing `()` AND the enclosing `()`

### Jumping with text objects

One of the most powerful features of text objects is that they have looser requirements on where your cursor needs to be in order to work. PLUS, they move your cursor for you as part of the command!

For example, take a look at the following block of code:
```ruby
def some_cool_method(foo: nil)
  # some cool logic
  foo || "bar"
end
```
If I put my cursor on the `c` in `some_cool_method` and run the following commands, what do you think will happen?

- `cw` (change word) - using `w` motion
  - `some_cool_method` -> `some_` (with cursor after `_`)
  - *This motion changes from the current location to the beginning of the next "word", in this case the `(`*
- `ciw` (change *inside* word) - using `iw` text object
  - `some_cool_method` -> ` ` (cursor ready to type out replacement of entire word)
  - *This is almost like a shorcut for `b`, then `cw`*
- `dt)` (delete until `)`) - using `t` motion
  - `some_cool_method(foo: nil)` -> `some_)`
  - *okay, but what if we want to delete only the contents inside the `()`?*
- `di(` (delete inside `()`) - using `i(` text object
  - `some_cool_method(foo: nil)` -> `some_cool_method()` (with cursor inside empty parens)
  - *This was almost like a shortcut for `f(`, `l`, `dt)`!*

Notice how the commands using text objects above actually move the cursor as part of the requested operation. Using an `iw` text object is analogous to moving the cursor to the beginning of the word, and then using the "word-wise" operation, and using a text object like `i(` moves the cursor to the inside of the parentheses, and this works whether you're inside or outside the parentheses to start with!

What about if there are multiple matching text objects on the same line? *Text object commands will operate on the "next" matching text object after the cursor.*

It'll take a little trial and error to get used to, but mastering usage of text objects and taking advantage of the jumps that they build in will massively level up your Vim-fu!

### A Note on Count-based commands

It's worth noting that most Vim motions can also accept a count. For example `j` will go down one line, but `5j` will go down 5 lines. The rule that any operator can be combined with any motion also applies to motions with counts, so something like `c3fe` can be used to edit from here up to and including the "third" `e` on the line. or `d5w` can be used to delete from here to the fifth "word" from here.

These count-based motions definitely have their place, and when combined with relative line numbers they are especially useful for precise vertical movements.

But as a recent convert from non-Vim, non-modal editors, you might find yourself thinking that trying to get the right count for things while hammering out commands is harder than it initially looked. Luckily, you can be a vim wizard just fine without using counts for your motions in your day to day.

It's also worth noting that using counts in your commands might be able to give you the blissful satisfaction of executing a perfectly targeted, surgical command, but baking counts into your commands might make them less reusable.

### Doing Things Again, Undoing and Redoing

Now that we know how to compose `operators` and `motions` to create `commands` it's time to talk about an extra special tool that will really take our Vim-fu to the next level.

- Enter `.` - aka the "dot repeat" command
  - `.` is quite possibly the most powerful key on your keyboard, allowing you to repeat any command you just executed, as many times as necessary

For our first example, let's say you just ran a `dap` to delete a paragraph and one of its surrounding new lines - now move to another and hit `.` and BOOM, you'll delete that paragraph too, with a single keypress!

This one's even better, let's say you just ran a `ci(` and typed out some text inside a pair of parens - Now you can jump to another pair of parens and hit `.` and BOOM, the same substitution will be made there too, no additional typing required

Now let's say you got a little trigger happy with you `.` spamming and ended up replaying a command one (or a few) too many times. No worries, just hit `u` to undo!

- `u` - undo the last `command`
  - *Think `ctrl+z`/`cmd+z` in non-vim editors (but don't press this in vim!)*
  - *PRO TIP: if you ever accidentally hit `ctrl+z` in vim out of muscle memory and your screen disappears, don't panic! You just stumbled upon the "suspend" command in `zsh`. Hit `fg` to bring yourself back to vim.*

> [!NOTE]
> `u` will undo any individual command, including usage of `i` or `a`!
> So if you enter `INSERT` mode with `i`, type some stuff out, then exit with `ESC` and hit `u`, eveything you just typed out will be "undone". This is because `i` is a `command` in insert mode, just like all the others

It's entirely possible that you accidentally hit `u` a few extra times too, so to undo your undo, you can also "redo" with `<C-r>`!
- `<C-r>` - redo the last `command` you just undid with `u`
  - *Think `ctrl-y`/`cmd+y` in non-vim editors*
  - *`<C-y>` in vim does something different - it scrolls the screen up one line (less scary than hitting `ctrl+z` accidentally). `<C-e>` is the complimentary keymap for `<C-y>`.*

### Optimizing for repeatability of commands

Think back to our section on count-based commands above. Now that you know about the `.` command to repeat any previous command, can you see how using counts in your commands might backfire?

With text object-based commands, we not only get free jumps along with our commands, we also get more powerful reusability. You don't need to be aware of how many "words" you're about to operate on, or how many lines you're going to jump when you repeat your command, you just need to know what kind of text object your command will target.

It's up to you how you use the new vim-fu superpowers you're acquiring, but it's definitely recommended to take advantage of powerful tools like the `.` command.

### Vim's better alternative to "multi-cursor" features

Here's another slick vim trick that leverages the `.` command:

- `cgn` - "change next match"
  - This command performs a "change" on *the next match for your latest search*
  - *The best part - this command is dot-repeatable*

If you've spent any time at all in one of the popular GUI editors, you'll probably remember the "multi-cursor" features in there. For example, in VSCode, you could highlight a string of text and then hit `cmd+d` (on mac) to highlight the next occurrence of the same string of text. hit it again for a third string highlighted, and so on. Once you had all the strings highlighted that you wanted to change, you could start typing and change all of them at once.

Yeah, this was kinda cool. And no, vim can't do this... but it can do something even better.

You see, that multi cursor approach looks fancy and all, but it had its fair share of problems. For one, there was no way to "skip" an occurrence of the string you originally highlighted. If you `cmd+d` a few times and realized you highlighted something you didn't want, you'd have to click somewhere to deselect everything and start over with a more specific string. In some cases, it wasn't even possible to highlight all the occurrences you wanted to target, if your match was too ambiguous.

Well vim doesn't have that problem, because instead of multi cursors, we have `cgn` + `.`.
Let's look at an example:

```ruby
{
  some: false,
  values: false,
  to: false,
  change: false,
}
```
Now let's say you want to change some of the values in this hash to `true`, but not all of them. Maybe you want to leave the value of `to:` as `false` and change the rest. Here's how you could do that with `cgn` and `.`:
- `/false`
  - *first, search for the string you want to replace, the cursor will land on the first `false`*
- `cgn` + type out `true` and hit `Esc`
  - *This is the `command` that we'll be repeating! It replaces the first `false` with `true`*
- `.`
  - *This will immediately "replay" the `cgn` you just did, replacing the next `false` mapped to `values:`*
- `n`
  - *This will jump us to the `false` mapped to `to:`, which we don't want to replace*
- `n`
  - *Another press of `n` gets us to the `false` mapped to `change:`*
- `.`
  - *And one last `.` finishes replacing the last `false` mapped to `change:` with `true`*

Unlike in VSCode, where small mistakes in this process will likely require undoing and starting over, each of these steps can be done or undone easily, without any wasted time or energy! Repeat your change with `.`, skip over matches you don't want to change with `n`. Accidentally changed one you didn't mean to? undo with `u`. Accidentally skip too far? Go back to a previous match with `N` and continue where you left off. Want to skip the `/false` search entirely? just put your cursor on `false` and hit `*` to populate your search instead.

### Introducing Marks

While we're on the topic of things Vim can do that VSCode can't, let's get acquainted with `marks`!

Marks are basically bookmarks that you can place around in your files so that you can jump back to them later. There are even some that are placed for you automatically that you can take advantage of too.

Placing a mark is easy, simply use the command: `m`, followed by an upper or lowercase letter.

Jumping to a mark is also easy:  `'` (single quote) followed by one of the letters you marked will move your cursor to the location of that mark.

- `m<letter>` - place mark `<letter>`
  - *`<letter>` can be basically any alphanumeric character, some characters are reserved*
- `'<letter>` - jump to mark `<letter>` (line start)
  - *This one will jump to the beginning of the line with the mark (first non-whitespace character)*
- ``` `<letter> ``` - jump to mark `<letter>` (w/column)
  - *This one will jump to the line AND column where the mark was originally placed*

To see the full set of marks available to jump to at any given time, use the `:marks` command.

#### Important - Know the difference between Lowercase and Uppercase `marks`
- `[a-z]` - Lowercase marks are "buffer local", meaning they're only relevant for the current buffer
  - *`ma` in one buffer and then `'a` in another buffer will not jump you to the mark you just placed*
  - *This also means you can have multiple `a` marks in multiple buffers simultaneously*
- `[A-Z]` - Uppercase marks are "global", meaning they're relevant accross buffers
  - *`mA` in one buffer and then `'A` in another buffer WILL jump you to the mark you placed in the other buffer*
  - *This also means you CANNOT have multiple `A` marks in multiple buffers. Placing another `mA` mark will remove your previous one*

Getting to know marks and making good use of them will make navigating back and forth through a codebase a lot easier, especially if you work across multiple files at a time!

### Taking Advantage of the Jumplist

So you know how your editor is tracking every change you make, right? Otherwise you wouldn't be able to reliably `u` (undo) and `<C-r>` (redo) commands.

Well, it's not only tracking each command you execute that makes a change, it's also tracking every movement you make in between! In Vim, this is called the "jump list". You can even inspect this list by running the command `:jumps`, check it out!

Anyways, the jumplist isn't just there for show! You can use the jump list to "undo" and "redo" jumps just like how you can undo and redo changes. Give these keybinds a try:
- `<C-o>` - Jump "back" in the jumplist
- `<C-i>` - Jump "forward" in the jumplist

One of the coolest parts about the jumplist - It's always tracking, and even tracks jumps accross files! so if you have two files open, you can mark two spots with global marks, but then once you start making some edits and get away from your marks, you can traverse the jumplist to move back and forth through your previous locations, marked or not.

### Wrapping up `NORMAL` mode

There are just a few more `NORMAL` mode commands worth mentioning before moving on:

- `x` - "char-wise" delete
  - *Similar to `d` but only operates on a single character, no motion required*
  - *Equivalent to `dl`, can come in handy for quick fixes to typos*
- `r` - "char-wise" replace
  - *This one is a bit like `x`, but instead of deleting the character under the cursor, it replaces it with whatever character you type next*
  - *Example: `r.` will replace the character under the cursor with a `.`. This command is also handy for quick typo fixes*
- `~` - "char-wise" toggle case
  - *Turns individual lowercase letters into their uppercase forms or vice-versa*
- `>`/`<`/`=`- `indent`/`de-indent`/`auto-indent` operators
  - *give these a text object to modify indentation from `NORMAL` mode*
  - *Or just double tap them to turn them into line-wise commands*
- `zz` - Center the viewport on your cursor
  - *`zt` and `zb` for "top" and "bottom" variants, these are all handy for visually moving your window around without moving your cursor's position in the file*
- `:` - Enter `COMMAND` mode
  - *We'll talk more about `COMMAND` mode later*
- `v` - the "visual" mode operator
  - *This special operator can be used to enter `VISUAL` mode with an initial selection, using the same motion/text object pattern as other `operators` in `NORMAL` mode*
  - *More on `VISUAL` mode in the next section!*

> [!NOTE]
> This is not an exhaustive list of `NORMAL` mode commands and operators. There are plenty of others, but they didn't make this list of "essential" Vim tricks.
>
> If you get through this whole guide and master all the essentials, there's always the `:h` docs just a couple keystrokes away to sate your curiosity.

## Vim's `VISUAL` Mode

`VISUAL` mode in Vim might be more familiar than `NORMAL` mode to new vimmers coming from GUI editors. It's kinda like what you'd get if you were to hold down `shift` and then press some arrow keys to move around and increase your selection. In vim, you'd be able to experience the same if you were to hit `v` and then start hitting arrow keys or `hjkl` directions.

But that's where the similarities end, of course! Let's start off by looking at the different ways you can enter variations of `VISUAL` mode:

### Entering `VISUAL` Mode

- `v` - Operator to enter "standard" `VISUAL` mode, aka "char-wise" `VISUAL` mode
  - *use `v` + any motion or text object to enter visual mode and highlight from your starting point to the end point of your motion/text object*
  - *Example: `vt(` to highlight from the cursor's position up until the next `(`*
  - *Example: `viw` to highlight the current "word" under the cursor*
  - *Example: `va{` to select the next enclosing `{}` pair and its contents*
  - *Note: The "Cap + double-tap" pattern doesn't apply here!*
- `V` - Enter `VISUAL-LINE` mode
  - *In this variation of `VISUAL` mode, your selection always spans entire lines*
- `<C-v>` - Enter `VISUAL-BLOCK` mode
  - *Vim's wackiest variation of `VISUAL` mode - in this one your selection is a "block" giving you precise control over the height and width of your selection*

In all of these variations of `VISUAL` mode, your cursor continues to posess the same movement capabilities as it does in `NORMAL` mode, so you can use all your favorite motions to adjust the size of your selection.

There is one special new motion that you get access to only in `VISUAL` mode:

- `o` - swap side of selection
  - *This is a super cool feature of Vim!*
  - *Didn't start your selection where you wanted to? No problem, just `o` to the other side and move it to wherever you want it to go!*

Thanks to this special `VISUAL` mode only mapping, `VISUAL` mode is your go-to tool for whenever you want a super precise selection. If you mess up your selection and lose it, no worries, you can always `gv` to pick up wherever you left off in your last foray into `VISUAL` mode.

### Operators in `VISUAL` Mode

Once you've got a selection you're satisfied with, `VISUAL` mode gives your access to a bunch of familiar operators:

- `d` - `delete` (cut) the selection
- `y` - `yank` (copy) the selection
- `c` - `change` the selection (cut and drop into insert mode)
- `p` - `paste` whatever you recently cut over the current selection
- `>` - `indent` the selection
- `<` - `de-indent` the selection
- `=` - `auto-indent` the selection

Plus a slightly special one:
- `:` - Enter `COMMAND` mode on the current selection
  - *This will pre-populate your command line with `:'<,'>`, which makes the next command operate on the text between the start of your selection and the end of your selection*

> [!TIP]
> Curious what `:'<,'>` really means? We'll talk about `COMMAND` mode more later, but for now you should at least recognize `'` as the command to jump to a mark. In this command line input, we can see `'<` and `'>`. These are two of the special marks that Vim keeps track of for you: `'<` marks the beginning of your latest `VISUAL` mode selection and `'>` marks the end of it. You can also type these out into your `:` command directly from `NORMAL` mode to get the same effect as hitting `:` from `VISUAL` mode, if you like doing things the hard way, that is.

### Vim's `VISUAL-BLOCK` Mode

Regular `VISUAL` mode and `VISUAL-LINE` mode are both pretty straightforward and you can probably imagine their common use cases. `VISUAL-BLOCK` mode is a bit different though.

Unlike the other two variations of `VISUAL` mode in Vim, `VISUAL-BLOCK` mode doesn't make just *one* selection. When you make a block selection, you're actually making one selection for each line that your block selection crosses.

This can be a bit tricky to wrap your head around at first. Let's look at an example:

```ruby
A = "A"
B = "B"
C = "C"
```
Try using `VISUAL-BLOCK` mode to select the vertical column of `=` in the above block. now hit `c` and change the `=` to a `-` and hit `Esc`. You should have seen yourself drop into insert mode on one line, then that one change you did should have been applied to all the highlighted lines when you hit escape. Pretty cool, right? This is the main use case of `VISUAL-BLOCK` mode - making changes to arbitrary columns of text! Try it out with the `I` and `A` commands too

> [!TIP]
> `VISUAL` modes in Vim are pretty powerful and definitely have thir use cases, but for most common tasks that would involve making a selection, if you can figure out how to do what you want with commands using motions or text objects instead, you'll likely find that you won't need to reach for `VISUAL` mode too often. `VISUAL` mode should ideally be reserved for use cases that truly require a manual selection to be made. That, or when you just want to highlight some code to show someone something!

### Vim's `COMMAND` Mode

We touched on this a bit earlier, but getting to command mode is as simple as typing `:` from `NORMAL` mode. This will open up the "command line" at the bottom of the window, and you can type out commands there in a similar fashion as you would type out text in `INSERT` mode. Once you're satisfied with your command, hitting `<CR>` (Enter) will execute it.

We also mentioned a few `COMMAND` mode commands earlier, like `:reg`, `:jumps`, and `:marks` and `:h`. Now we'll take a look at some even more essential commands

- `:w` - write
  - *Saves your current file*
  - *Think of this one like `cmd+s` on mac*
  - *This command can also take a filename - useful if your current file doesn't have one already, or if you want to write to a new path*
- `:q` - quit
  - *Closes your current window (and Vim, if that was your last open window)*
  - *This command will stop you if you have unsaved changes - to quit without writing unsaved changes, add a bang: `:q!`*
- `:e <filepath>` - edit
  - *Opens a new buffer for the file at path `<filepath>`*
  - *This command is like `cmd+o` for "open" on mac, though you can also open new files that don't exist yet by passing an unused filename*
- `:sp`/ `:vsp` - horizontal / vertical split (or `<C-w>s`/`<C-w>v`)
  - * `:sp`/`<C-w>s` Splits the current pane horizontally, moving the cursor to the new pane below the current one, and `:vsp`/`<C-w>v` does the same but vertically, moving the cursor to the new pane to the right of the current one*
  - *Note that the new panes these commands create still contains the same buffer that you split from - you now have two windows looking at the same buffer*
  - *To move around between splits, use `<C-w>` + `h`/`j`/`k`/`l`, or arrow keys*
  - *`<C-w>w` is a shortcut to swap between your current and previous window*
- `:buffers` / `:ls` - inspect the buffer list
  - *Similar to the other `:reg` and `:marks` commands we mentioned earlier, but this one shows you a list of all the buffers you currently have open*
  - *Each buffer in the list has a number associated with it, and you can use that number to switch to that buffer with `:b <number>`
  - *`:b #` acts as a shortcut to swap between your current and previous buffer*
- `:bn` / `:bp` - next/previous buffer
  - *These commands allow you to cycle through your open buffers*
  - *You can also use `:bnext` and `:bprev` if you prefer typing out the full command*

These commands are just the most basic of basics, but with these bare essentials you should be able to get around in vanilla Vim just fine. If you want to know more about any of these commands, you can always use the `:h <command>` command to read the help docs for that command (e.g. `:h :w` to read about the `:w` command).

### Vim's Powerful Find and Replace

No discussion of `COMMAND` mode would be complete without mentioning the powerful `:s` command! This command stands for "substitute" and is used to find and replace text in the current buffer.Let's take a look at how it works:

```
:<range>s/<find>/<replace>/<flags>
```

- `<range>` - The range of lines to apply the substitution to (optional)
  - *If you don't specify a range, it will default to the current line*
  - *You can use `%` to operate on the entire file, or `1,10` to operate on lines 1 through 10*
  - *Use `.` as a reference to the current line, so `.,20` will operate on the current line to line 20*
  - *You can also use `'<,'>` to operate on the current selection in `VISUAL` mode*
- `<find>` - The text to find (required)
  - *This pattern can be a simple string or a regular expression*
  - *for details on how to use regex in Vim, check out `:h pattern`*
- `<replace>` - The text to replace the found text with (required)
  - *This can also be a simple string or a regular expression*
  - *You can use `&` to refer to the entire match in the replacement text*
- `<flags>` - (optional) Flags to modify the behavior of the substitution
  - `g` - Global replacement, replaces all occurrences in the specified range
  - `c` - Confirm each replacement before making it
  - `i` - Case-insensitive search
  - *These are just a few of the most common flags, you can find the rest at `:h :s_flags`*

That probably looks like a lot to take in, so let's look at a couple concrete examples:

```ruby
def some_cool_method(cool, stuff)
  puts "cool stuff: #{cool} and #{stuff}"
end
```

Let's say you want to change the name of the `cool` parameter to `awesome`, how would you do it? You could use the `cgn` trick we learned earlier and skip over the `cool` that appears in the string, but let's take the `:s` command for a spin instead:

Try running `:%s/cool/awesome/` and see what happens...

```ruby
def some_awesome_method(cool, stuff)
  puts "awesome stuff: #{cool} and #{stuff}"
end
```

Uh oh! It changed the `cool` in the method name and the string, but not the `cool` parameter at all! That's because our first attempt at using the `:s` command is doing a simple string match for the first occurrence of `cool` on each line. In order to make it match each occurrence of `cool` on every line, we need to add the `g` flag to the end of our command. Undo that last change, and let's try again with `:%s/cool/awesome/g`...

```ruby
def some_awesome_method(awesome, stuff)
  puts "awesome stuff: #{awesome} and #{stuff}"
end
```

This time we changed the parameters, but we're still changing every occurrence of `cool` in the file, including the one in the method name and the one in the string. Let's undo and try again with a slightly different pattern: `:%s/\<cool\>/awesome/g`...

```ruby
def some_cool_method(awesome, stuff)
  puts "awesome stuff: #{awesome} and #{stuff}"
end
```

This time we surrounded our search term with `\<` and `\>`, which is the Vim way of saying "match only the whole word". This way, we only match the `cool` parameter and not the other occurrences of `cool` like the one in the method name. We still matched the one in the string though, so let's undo and try one more time with `:%s/\<cool\>/awesome/gc`...

This time, Vim will prompt you for confirmation before making each replacement. You can hit `y` to confirm the replacement, `n` to skip it, or `a` to replace all occurrences without further confirmation. This is a great way to make sure you're only changing what you want to change! With a `y` for the `cool` in the parameter list, `n` for the next occurrence in the string, and `y` for the last occurrence, we end up with our desired result:

```ruby
def some_cool_method(awesome, stuff)
  puts "cool stuff: #{awesome} and #{stuff}"
end
```

### Advanced Vim Tricks: Macros

Sometimes you want to do something a little more complicated than you have the patience to figure out a regex for. Or you notice that you need to do more than just a find and replace operation, but your task at hand still involves some repetition. Vim's got the perfect tool for that kind of scenario - `macros`.

Vim macros basically let you record a sequence of normal mode commands and then allow you to replay them. Here's how to use them:

- `q<register>` - start recording into register `<register>` (e.g. `qa` will record into register `a`)
  - *You'll see a little "recording @<register>" message in the bottom of your screen once recording starts*
- `q` - stop recording your macro
- `@<register>` - play macro recording out of `<register>` (e.g. `@a` will play the macro recorded in register `a`)
  - *This command can also take a count, for example `10@a` will play the `a` macro 10 times*
- `@@` - repeat the last played macro
  - *Also takes a count - `10@@` to replay the last macro 10 more times*

Let's take a look at a basic example:
```ruby
TWO,
THREE
FOUR
```
Let's say you just pasted a bunch of contents into an array and now you need to add a comma to the end of each. You could go to each line, run `A,`, then `Esc` and `j` and repeat as many times as you need, but if there's a bunch of these, this approach could take a while. This is a perfect use case for a simple macro!

- Put your cursor on the first line you want to change and hit `qa` to start recording to register `a`
- Now, run your edit - `A,`, `Esc`
- Next, hit `j` once to go to the next line, and then `q` to stop recording your macro
  - *Thanks to the usage of `A`, it doesn't matter where on the line we end up in each iteration*
- Now you can press `@a` to replay your macro! You should see the same change made on the second line, and your cursor should end up on the third.
- Finally, you can either mash `@@` as many times as needed to finish up your changes, or take a look at how many more lines need the treatment and use that count!

See, macros are easy! You aren't limited to simple changes like the one we did in this example - any time you find yourself needing to make some repetitive changes, you can probably use a macro to save yourself some effort.

### Advanced Vim Tricks: Registers

Once you get this far, it's probably worth learning a bit more about registers. Macros use them, as you just learned, but so do just about all the other commands that involve doing something with text! For example, when you `y` to yank some text, by default Vim puts that text in the `"` register, also referred to as the "default" register. By default, the `p` command also pastes from this register.

`d`, `c`, `x` - all of these commands also put the text they "cut" into the default `"` register. This is how your cut/copy/paste commands all work in sync by default, they all either put text into, or take text out of the same register.

We're not "stuck" using only this default `"` register though! You can modify any of the mentioned commands' behavior to use a different register by prefixing the command with a register specification, using `"<register>`.

One of the most common use cases for this is when you want to truly "delete" text, instead of "cutting" it:
- `"_d` - delete to the "black hole" register `_`
  - *The next time you `p`, you won't see this text you deleted come back*

If you want to yank something without "overwriting" whatever else you most recently yanked (whatever is currently in the `"` register) you can always yank more text to a different register:
- `"xy` - yank to register `x`
  - *This effectively means you have have multiple things "yanked" at any given time - `"xp` to pasted the text you yanked into the `x` register*

Now to really blow your mind - Macros under the hood are just more text in a register, the same as any other text you might yank or delete! Try pasting out the contents of the `a` register we recorded our macro to earlier with `"ap`:

You should see something that looks like this:
```
A,^[j
```

Well how about that - those are the exact commands we executed in our macro! Don't be alarmed by the `^[` in there, that's just how Vim represents `Esc`. With this new trick though, you can now record any macro you like, print it out, modify it, and yank it back into a register to be used again! This is especially handy if you were in the process of recording a complicated macro and messed it up somehow. Since you know what register it's in, you can always pull it out and fix it!

### Advanced Vim Tricks: Configuration and Beyond

At this point we've gone over all the essentials you should really know about vanilla Vim. You're familiar with `INSERT`, `NORMAL` and `VISUAL` modes, you know a handful of key `COMMAND` mode commands, you've got a basic understanding of `marks`, the `jumplist`, `macros` and `registers`. You're ready to hit the ground running on any Vim distribution with these core skills.

This isn't the end of your Vim journey, however. There's plenty more to learn, and you're sure to find out quickly that one of the deepest rabbit holes in Vim is personalization. Every Vim editor configuration you come across will likely have unique quirks about it, thanks to all the developers that used it before you finding new ways to optimize their individual workflows. Nearly almost all of the essentials you learned here should still "work" in any Vim or Vim-derivative editor (like Neovim), but there will probably be even better ways to do things, thanks to the thousands of open source plugins that exist to extend the functionality of Vim beyond the essentials.

Learning how Vim configuration works is best done one small tweak at a time. Starting with `:options` is recommended, since they all have entries in `:h` to reference and can be modified in-editor with the `:set` command.

Once you get reasonably comfortable with options, expand your learning to custom keymaps, and then to plugins. If you're working with Neovim (and you probably are if you're reading this guide), it's also worth getting a basic understanding of its configuration language, `lua`.

Here's a quick example of what you can do to modify your Vim experience to your liking (using lua in Neovim):
```lua
-- Yank to the system clipboard (register +) with \y
vim.keymap.set({"n", "v"}, "<Leader>y", '"+y')
```

> [!TIP]
> That's just a small taste of what you can do in a customized Vim/Neovim config! Little aliases like this one are great for reducing friction in your workflow, but pretty much anything you can code can go into some kind of customization for your editor.
>
>This rabbit hole is deep, so wait to dive into it until you've got a good handle on the essentials!

With this, congratulations are in order! You've made it to the end of Essential VIM. Don't be afraid, and remember - *deliberate, consistent practice* is the key to leveling up your Vim-fu. You'll be a vim wizard in no time.

Happy Vimming!

