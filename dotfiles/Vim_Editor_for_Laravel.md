# Vim Editor for Laravel
Setup quick:

    sudo apt install kitty  # install kitty both in macOs and homestead for my case
    
    wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    chmod u+x nvim.appimage && ./nvim.appimage
    # if we gets any error: sudo apt-get -y install libfuse2
    
    sudo mv nvim.appimage /usr/local/bin/nvim
    
    
    echo alias vim=nvim >> .zshrc
    source .zshrc
    
    sudo apt install fzf
    sudo apt-get install ripgrep
    sudo apt-get install dos2unix 
    export PATH="$HOME/.local/bin:$PATH"
    cd dotfiles
    dos2unix install
    # comment the kitty configuration as I am using in in MAC machine and nvim is in vagrant
    ./install
    
    tmux
    vim
    :e nvim/lua/user/plugins.lua
    :PackerSync
    
    cd .local/share/nvim/site/pack/packer/opt/phpactor && composer install --no-dev --optimize-autoloader




# Setup:
1. Install zsh in linux:
    1. https://www.tecmint.com/install-zsh-in-ubuntu/
    2. https://www.youtube.com/watch?v=Vj54klRlwIE
    3. https://ohmyz.sh/
2. Add zsh configuration from Jess:
    1. https://github.com/jessarcher/zsh-artisan
3. Neovim:
    1. https://github.com/neovim/neovim/wiki/Installing-Neovim



1. Install zsh in linux
    sudo apt install zsh
    
    #set zsh package manager
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    
    #install artisan
    git clone https://github.com/jessarcher/zsh-artisan.git ~/.oh-my-zsh/custom/plugins/artisan



# Basic Vim Command

**Modal Editing and moving around:**

- Inset mode: press button `i`
- for back to normal mode `esc` button
- press `yy` for copy the current line
- press `5p` for paste it 5 times. 
- use `hjkl` for moving the cursor respective left, down, up, right and it is moving only with complete line
- press `v` for visual mode: now the line will be selected visually when moving the cursor
- press `V` (shift)for visual mode but now it will select entire row when moving the cursor
- press `cntl` `v` for visual block mode to select block when moving the cursor, press `o` to move the cursor position in the opposite direction. 
- For adding text in the beginning of the rows: 
    - Move the cursor to the first row from where we want to edit
    - Press Cntl `v` for select visual block mode
    - Move the cursor down and select some rows.
    - Press Shift `i` for change the mode to insert
    - edit the selected first line 
    - Press `esc` button and the changes has been applied to all the rows.
- For adding text in the endding of the rows
    - Move the cursor to the first row from where we want to edit
    - Press Cntl `v` for select visual block mode
    - Move the cursor down and select some rows.
    - Press `$` for moving the cursor to end and selecting the rows
    - Press Shift `a` for change the mode to insert for appending
    - edit the selected first line 
    - Press `esc` button and the changes has been applied to all the rows.
- Command:
    - when it is in normal mode, press `:` for applying command
- File Edit / Save:
    - `:w` save the changes in the file if the file name  already exist
    - `:w test.txt` save the changes into a new file with name test.txt
    - `:wq` save and quit
    - `:q` quit the file (works only when there is no change buffer)
    - `:q!` quit forcefully though it has some change buffer
    - `:wqa` , `:wa` , `:qa` , `:qa!` for save, and quite all the open buffer
    

**Managing Files with Buffers:**

- Open file in vim: `vim test.txt`
- Or open the vim using `vim` command and type `:e test.txt` . If the file not exist, it will create a new
- If we need to create a new file: `enew` will create unname new buffer
- To see all the open file buffer: `:ls` and it will show list of buffer
- to move the buffer, press `:b filename.txt` or `b: buffer_numer`
- Toggle two recent buffer: `cntl + shift + 6` 
- Split buffer:
    - Horizontal split -  `:sp`
    - close the split -  `:q`
    - Vertical Split - `:vs`
    - For toggle between two split window -  `cntl + w +  h` for left window and `cntl + w +  l` for right window
    - By default it opens, same buffer in the both of the split, we can change it using `:b filename` in the selected window
- Tab: Normally using tab, vim open to new layout:
    - create new tab: `:tabnew`
    - Move to the previous tab: `:tabp`
    - Move to the next tab: `:tabn`


**Motions, Commands, and Text Objects:**

- Set line number → `:set number`
- Move to the last line →  `shift + g + g`
- Move to the top line →  `g + g`
- Move to a specific line → `line no + shift + g`
- Move one word in the forward → `w` if we want to consider only space as boundary of the word `shift + w`
- Move one word in the backward → `b` and if we want to consider only space as boundary of the word in backward `shift + b` only consider the space as boundary so comma will be skip in this case.
- To move the first position of the line → `0` and for non white space character → `shift + 6`
- Move to the end of the line → `shift + 4` or press the `$`
- Undo → `u`
- Redo again → `cntl + r`
- To find a character next to my cursar → `f + letter` and use `;` to the next match and `,` to the previous match
- To move the cursor just the beginning to a word like searching → `t + letter`
- Search a word → `/word` and hit `enter` button 
    - For moving forward `n`
    - For backward → `shift + n`
    - remove highlighting → `noh`
- when cursor is in a word, press `shift + 8`, it will highlight all the matching word and move the cursor to the second found word.
    - For moving forward `n`
    - For backward → `shift + n`
    - remove highlighting → `noh`
- For adding parenthesis, move to the beginning of the word and make it insert mode and add `(` and make it normal mode. Press `e` to move to the end of word and press `a` to append `)` and move the normal mode, we can toggle between these parenthesis by pressing `shift + 5` or `%` in the normal mode.
- In visual mode, if our cursor is in the ending parenthesis and we can use `%` to select the whole word inside parenthesis
- To select all the of the text in the file:
    - press `g + g` to move the cursor to the top line 
    - press `shift + v` for the visual line mode
    - press `shift + g` to select the whole text in the line
- Add text regradless my cursor in the line, 
    - `shift + i`  for inserting the text in the beginning of the line
    - `shift + a` for inserting ending to the line. 
- Press `x` for deleting one character and use `u` to undo
- Press `dw` for deleting an word and press `.` for repeating it again and again and `u` for undo
- If we want to delete the word along with the , or other character, press `d + shift + w`
- To delete every from the cursor position to the start → `d + ^` and delete from the cursor to the end of the line → `d + $` or `shift  + d`
- delete every upto select character → `d + t + ,`   here it will be deleted upto the ,
- delete the current line `d + d` and delete multiple line `4 + d + d`
- change word → `c + w`, it will delete the word and make it insert mode for the new word
- change until , → `c + t  + ,` and change the while line `c + c` or `shift + c` to change the end of the line
- Copy and paste:
    - copy the word here the cursor is in `y + w` and paste `p`
    - Copy the whole line → `y + y` and paste `p` . And for pasting multiple times, `5 + p`
    - If we want to paste the copy text above the line → `shift + p`
- Add new line `o` for adding new line in the next line and `shift + o` for adding the new line above the line. 
- Visual Mode (`v`):
    - select `i + w` to select inside the word
    - select `a + w` to select around the word
- Delete inside the word: `d + i + w` and delete around the word `d + a + w`
- Delete incluside , in the word: `d + i + + shift + w` and delete around the word `d + a + shift + w`
- Mutitple word inside parenthesis like (nice and new): 
    - Visual mode (`v`) : `i + )` will select inside everything parenthesis
    - Visual mode (`v`) : a `+ )` will select everything including parenthesis
    - change everything inside parenthesis: `c + i + )`  
- Jump:
    - move to the cursor bottom `shift + g`
    - move to the previous position → `cntl + o`
    - move the the forward position → `cntl + i`
    - it is very handly for back and forward in multiple file. Even though if we close the file and open again, vim remember the last position and we can move it by `cntl + o`
- To see the documentation of the Neovim:
    :Tutor


**Dotfiles:**

1. install kitty terminal 
    sudo apt install kitty
2. download fonts:

https://www.nerdfonts.com/font-downloads

    # unzip the file and move folder to the following location
    /usr/share/fonts
    # for macOS unzip all the folder and copy all the fonts inside here and then paste it to Font Book 
    
    #show the fonts using kitty
    kitty list-fonts


3. for changing the themes for kitty
    kitty +kitten themes


**Tmux:**

- create new window `cntl + b` and then press `c`
- switch between window `cntl + window no` or `cntl + p` for previous window and `cntl + n` for the next window. or just `cntl + b` and then arrow left or right
- To split the window `cnt + b` and then `shift + 5` or `%` 
- To create a new session: 
    - `cntrl + b` and then `:new-session -s session-name`
- To show all the session in tmux: `cntl + b` and `s`
- To detached from tmux to terminal `cntl + b` and `d` and if we `tmux` again , it will show all the existing tmux session
- To close the pane: `cntl + b` and then `x` to confirm
- And close the window using `cntl + d` or write `exit`
- Kill the entire session of tmux by using this command: `tmux kill-server`
- custom setting:
    - Used `cntl + space` instead of `cntl + b`
    - `cntl + space + spac e` to swithc between recent two most windows
    - `^` for switching between sessions
- For installing fzf
    sudo apt install fzf
- For adding new session from the direactoy: `cntl + space` and `shift + f` and select the directory from the list
- Find and replace text:
    - `/searchword` and `cgn` and change it to the right word 
    - `esc` for normal mode 
    - `.` to do the same changes in the rest by every time press it



**Neovim Settings:**

1. `4 + k` to jump up 4 line and `4 + j` to down again
2. for see the auto searching option `:word + tab` in the option panel
3. to get any help from nvim command:
    1. `:help 'wildmode'` to see the help option for the command



**Key Mapping:**

- `j` and `k` will also up and down in the warp line also
- In visual mode:
    - `>` will indent the selected line to right and selection will be selected
    - `<`  will indent the selected line to left and selection will be selected
- In insert mode: `;;` to add ; in the last of the line and `,,` to add the , in the last of the line
- `space + k` instead of `:noh`
- Insert mode: `alt + j` or `alt + k` for moving the line to up and down (it is not working for me, need to check the settings)

Using Plugins:

- Select line in virtual mode and `=` to fix the indentation for the code
- `:PackerSync` to install the plugins
- `g + c +c` for commenting  a line
- Select multiple line using virtual mode and `g + c +c` to comment multiple lines
- Or 5 `g + c +c` for comment next 5 lines
- 



**Essential Plugins:**

- Add, change, delete surrounding text
    - `c + s +` `'` and press `"` to change the surrounding single quote to double qoutes and `.` key for doing the same thing for multiple places
    - `c + s +` `"` and press `<bold>` to change the surrounding to <bold> tag
    - `d + s + t` to delete the surrounding tags
- For opending a new pane: `cntl + space` and then `shift + 5` 
    - to toggle between panes `cntl + h` and `cntl + l`
    - `vs` for virtical split of the sceen again
        - `:only` to close the vs and keep remain the left original one
- `*` when cursor is on a word. It will search this in the file and highlight.
- move the cursor inside a html double qouted word and press `v + i + x` or `v + a + x` for selecting it very quickly
- `cont + u` and `cntl + d` for bigger jumps in scrolling
- `:vs` and open another file in the screen and use `:bdelete` to close the buffer and split together
    - `:Bdelete` will close the buffer but not close the split screen and we have a key map `space + d` to do this as shortcut
- {‘one’, ‘tow’, ‘three’} now press `g + S` to make it list and `g + J` to back again in line


**Color Schemes:**

- to change the follor `:colorscheme elflord` or any color
- Back to default color scheme: `:colorscheme default` and it will reset all the color settings
- Change the highlight color: `:hi Comment guifg=#bada55` 
- Add undercurl in the comment → `:hi Comment gui=undercurl` 
- Can be change the spell bad with like `:hi SpellBad gui=underline` or `:hi SpellBad gui=undercurl`
- use the following command to clean the packer package: `:PackerClean` 

**Improved File Navigation:**

- Open telescope with the command → `:Telescope`
- To select the option of the telescope, we can write the command like: `:Telescope find_files`
- Need to press `esc` two time, one for normal mode of the telescope and another is for the quit of the telescope
- Press `f + .` to move the cursor to the . in the line and `shift + d`  to delete everything from the cursor position to the end of the line. 
- We can set cursorline using the following command: `:set cursorline` to see the background color in the line selected and use the following command to reset it `:set nocursorline`
- Short cut for Telescope:
    - after opening the vim, we can use `space + f` to find the files using the finder
    - `space + F` to find the file including vendor and .git directory as well.
    - `space + B` to see the open buffers
    - `space + g` to find inside file (make sure rg is install)
        - for more advance search: `word` and then `cntl + k` to make the word inside code and then `-tfiletype` and then directory. Example: `"``telescope``"` `-tlua nvim/lua` 
    - `space + n` to open the side bar with file and folder list
    - 
- To install rg in the linux for improving searching inside file:
    sudo apt-get install ripgrep
- `:NvimTreeopen`  will open side bar of the file directory
- when the folder is select from the left menu we can add new file using `a` and after putting the name we can hit enter to open the file.


**Improving the UI:**

- after opening the file in `:vs` to split it and we can make open one using the `:on` for only
- We can move to buffer using `[b` or `]b` to toggle buffer in vim
- `space + q` to close the buffer
- 


**Git Integration:**

-  `]h` and `[h` for moving next and previous changes in the file 
- `gs` will stage all the changes file in git
    - In a new terminal `g status` will show the stage hunk
    - `g diff` `--``staged` will show all the file list
- `gS` will unstage the changes
- `gp`will preview the change or hunk
- `gb` will blame the line means to change the file
- `:g blame` in the command will show all the changes in the file
- `:GBrowse` will open the file in the browser with the git repo
- `:G` for getting the help list of the git


**Terminals Inside Neovim:**

- `:terminal` and `i` mode can be used a terminal in nvim and us `cntl + \ + cntl + n` to back to normal mode. `cntl + d` for quit the terminal session
- Open the new float terminal using `:FloatermToggle`

**Tree-sitter:**

- To select code section in virtual mode:
    - Parameter inner `ia` and around `aa`
    - Funcation inner `if` and around `af`

**Language Server Protocol (LSP):**

- For getting the lsp info → `:LspInfo` 
- Shortcut:
    - `g + d` for getting the defination file and `cntl + o` back to the previous position
    - `g + r` for getting the references or the use places
    - `shift + k` for getting the hover information and `shift + k` again for select inside the floating window
        - If we do two `shift + k` then, we need to `:q` for quit. Otherwise moving cursor to other place will disappear the floating window
    - `space + r + n` for rename (only in license version)
    - `space + d` will the show the erro in the line
    - `[d` and `]d` will move the cursor to multiple error position


**Autocompletion:**

-  press `tab` to select the suggestion model


**Linting and Formatting:**

- `:Format` for formatting the link command in the code


**Snippets:**

- `pubf` or `prof` or `prif` to create the method as shorcut and use tab button to auto comple as well as to move the parameter, return type and main body of the function
- `testt` or `testa` use for creating method for testing method and use tab like for above one

**Phpactor:**

- For setup:
        - move to `.local/share/nvim/site/pack/packer/opt/phpactor` and run `composer install --no-dev --optimize-autoloader`
- `space + p + m` for refactoring many code in php
- `space + p + n` for adding test class default config


**Projectionist:**

- `:A` for toggle between the test and orignial file and if the test is not created in the first time, it will show an option for creating it with all possible path file feature and unit
- We can open file in different type:
    - `:Emigration migration_filename` for find migration
    - `:Econtroller controller_filename` for find migration
- `:Start` for starting the php artisan server
- `:Console` to open the thinker

**Running Tests:**

- `space + t + n` run the nearest tests
- `space + t + f` run the current file tests
- `space + t + s` run the whole tests in the application
- `space + t + l` run the last test again
- `space + t + v` test visit - need to explore
- To close terminal: `F1` button or write: `:exit`


**Find and Replace:**

- `/word` for searching any word in the nvim
- change any word:
    - `:%s/word/replace` will show the live change and hit enter will change 
    - `:%s/word/replace/g` will show the live change and hit enter will change globally
- `: + upkey` to show the last command in the console.
- If we already search the word using `:/word` and select the word then we can replace it `:%s//replace` as shortcut
- Move to the top of the file again `:%s/word/replace/gc`  here c is for confirming the changes. It is like replace one word by one word.
- We can do the change in a selected area:
    - Select the effected line using visual line selection
    - `:<autobracket>s/word/replace
- Find every line which does not end with `>` symbol
    - `:%g/[^>]$/p` where /p is for printing this in the console
- Delete every single line which contains div → `:%g/div/d`
    - Delete every single line which does not contain div → `:%v/div/d`
- Change globally in the application:
    - `space + g` for global search using telescope
    - we can use tab key to select individual item here
    - If we want to change all the file here, `cntrl + q` for quick view and we can up and down to the list using `[ + q` or `] + q`
    - For change the text in quick view → `:cdo s/word/replace`
    - to check the changes: 
        - Open terminal `f1` button and type `g diff`
    - To close the quick view: `:ccl` 


**Automating Repetitive Changes:**

- type 0 and back to the normal mode and press `contl + a` to increment the number and `cont + x` to decrement the number
- In the select value, if we press `1998 or any value + cnt + a`, it will update the value with sum it up
- Inserting indexing:
    - `0` and `yy` and `15p` for pasting it
    - In visual mode select all and press `cntl + a` update all the value with one increment
    - If we want to increment is one from the previous one `g + cntl + a`
    - we can make 00 in every line and `g + cntl + a` for leading zero in the incremental value
- Macros:
    {
      "title": "Start world",
      "releaseYear": 1997
    },
    {
      "title": "Start world",
      "releaseYear": 1997
    },
    {
      "title": "Start world",
      "releaseYear": 1997
    }
    - Start macros `q + macro_name` example `q + q` 
    - change the json to html format using macros
        - delete the first line: `dd`
        - Now delete upto third “” in the line means upto movie name `3 + d +f` `""`
        - `f +` `""` to move the end of the line and `shift + d` to delete the line
        - `shift + j` to join the next line to the current line
        - `3 + d +f ""` to delect upto the year
        - press `i` and add `space + (` and and `esc` and `f + ""` to move the end of the line and `r + )` for replace 
        - and `shift + a` to append in the line and add `</h1>` and normal mode press `0` to move the start of the line and `i` and write `<h1>`
        - move the next line and delete the end section of the json
        - And make sure, we are in the very first position of the line
        - press `q` for stop recording and `@ + q` to repeat the macro
        - `@ +@` to repeat the last macro
        - `:Rname movie.html` to change the file name
    - In case we wan to do update the record
        - `:register q` will show the content of the q register
        - to copy paste the register: `"` `+ name of the register / q + p` in the file 
        - move the to the h1 and press `ctrl + a` for increment the value
        - Now move to the start of the line `0` 
        - `"` `+ w` and `yy` to copy the line
        - `:reg w` will show the new version of the register
        - Move to the top of the line and `@ + w` and repeat it for do the same thing using new macro



Fix error:

- For getting the list of deprecated method run the following command
    checkhealth vim.deprecated

