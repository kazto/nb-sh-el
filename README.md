# nb.sh.el

Emacs内から[nb.sh](https://nb.sh)を呼び出すEmacs Lispパッケージです。

## Testing

このパッケージには ERT (Emacs Lisp Regression Testing) を使用したテストスイートが含まれています。

### テストの実行方法

```bash
# バッチモードでテストを実行
make test

# インタラクティブモードでテストを実行（デバッグ用）
make test-interactive

# バイトコンパイル
make compile

# コンパイル済みファイルのクリーンアップ
make clean
```

### Emacs内でテストを実行

```elisp
;; テストファイルをロード
(load-file "test/nb-test.el")

;; 全テストを実行
(ert-run-tests-interactively 't)

;; 特定のテストを実行
(ert "nb-test-get-id-at-line-basic")
```

## Shortcuts

prefix: `C-c n`

| Shortcut key | Command        |
| ------------ | -------------- |
| C-c n RET    | `nb`           |
| C-c n a      | `nb add`       |
| C-c n b      | `nb bookmark`  |
| C-c n c      | `nb copy`      |
| C-c n d      | `nb delete`    |
| C-c n e      | `nb edit`      |
| C-c n f      | `nb folders`   |
| C-c n g      | `nb git`       |
| C-c n h      | `nb help`      |
| C-c n i      | `nb import`    |
| C-c n l      | `nb list`      |
| C-c n m      | `nb move`      |
| C-c n n      | `nb notebooks` |
| C-c n o      | `nb open`      |
| C-c n p      | `nb peek`      |
| C-c n r      | `nb archive`   |
| C-c n s      | `nb search`    |
| C-c n S      | `nb sync`      |
| C-c n t      | `nb todo`      |
| C-c n u      | `nb use`       |
| C-c n w      | `nb show`      |
| C-c n x      | `nb export`    |



```
Usage:

  nb
  nb <ls-options>... <id> | <filename> | <path> | <title> | <notebook>
  nb <url> <bookmark options>...
  nb add <notebook>:<folder-path>/<filename> <content>
         -b | --browse -c <content> | --content <content> --edit
         -e | --encrypt -f <filename> | --filename <filename>
         --folder <folder-path> --no-template --tags <tag1>,<tag2>...
         --template <template> -t <title> | --title <title> --type <type>
  nb add bookmark <bookmark-options>...
  nb add folder <name>
  nb add todo <todo-options>...
  nb archive <notebook>
  nb bookmark <ls-options>...
  nb bookmark <notebook>:<folder-path>/ <url>...
              -c <comment> | --comment <comment> --edit -e | --encrypt
              -f <filename> | --filename <filename> --no-request
              -q <quote> | --quote <quote> --save-source
              -r (<url> | <selector>) | --related (<url> | <selector>)...
              -t <tag1>,<tag2>... | --tags <tag1>,<tag2>... --title <title>
  nb bookmark list <list-options>...
  nb bookmark (edit | delete | open | peek | url)
              (<notebook>:<folder-path>/<id> | <filename> | <title>)
  nb bookmark search <query>
  nb browse <notebook>:<folder-path>/<id> | <filename> | <title> --daemon
            -g | --gui -n | --notebooks -p | --print -q | --query <query>
            -s | --serve -t <tag> | --tag <tag> | --tags <tag1>,<tag2>...
  nb browse add <notebook>:<folder-path>/<filename>
            -c <content> | --content <content> --tags <tag1>,<tag2>...
            -t <title> | --title <title>
  nb browse delete (<notebook>:<folder-path>/<id> | <filename> | <title>)
  nb browse edit (<notebook>:<folder-path>/<id> | <filename> | <title>)
  nb completions (check | install -d | --download | uninstall)
  nb copy (<notebook>:<folder-path>/<id> | <filename> | <title>)
          <notebook>:<folder-path>/<filename>
  nb count <notebook>:<folder-path>/
  nb delete (<notebook>:<folder-path>/<id> | <filename> | <title>)...
            -f | --force
  nb do (<notebook>:<folder-path>/<id> | <filename> | <title>)
        <task-number>
  nb edit (<notebook>:<folder-path>/<id> | <filename> | <title>)
          -c <content> | --content <content> --edit
          -e <editor> | --editor <editor> -l | --last --overwrite
          --prepend
  nb env -l | --long
  nb env install | update --ace | --mathjax
  nb export (<notebook>:<folder-path>/<id> | <filename> | <title>)
            <path> -f | --force <pandoc options>...
  nb export notebook <name> <path>
  nb export pandoc (<notebook>:<folder-path>/<id> | <filename> | <title>)
            <pandoc options>...
  nb folders (add | delete) <notebook>:<folder-path>/<folder-name>
  nb folders <list-options>...
  nb git checkpoint <message> | dirty
  nb git <git-options>...
  nb help <subcommand> -p | --print
  nb help -c | --colors | -r | --readme | -s | --short -p | --print
  nb history <notebook>:<folder-path>/<id> | <filename> | <title>
  nb import bookmarks | copy | download | move (<path>... | <url>)
            --convert <notebook>:<folder-path>/<filename>
  nb import notebook <path> <name>
  nb init <remote-url> <branch> --author --email <email>
          --name <name>
  nb list -e <length> | --excerpt <length> --filenames
          -f | --folders-first -n <limit> | --limit <limit> | --<limit>
          --no-id --no-indicator -p <number> | --page <number> --pager
          --paths -s | --sort -r | --reverse --tags
          -t <type> | --type <type> | --<type>
          <notebook>:<folder-path>/<id> | <filename> | <path> | <query>
  nb ls -a | --all -b | --browse -e <length> | --excerpt <length>
        --filenames -f | --folders-first -g | --gui
        -n <limit> | --limit <limit> | --<limit> --no-footer --no-header
        --no-id --no-indicator -p <number> | --page <number> --pager
        --paths -s | --sort -r | --reverse --tags
        -t <type> | --type <type> | --<type>
        <notebook>:<folder-path>/<id> | <filename> | <path> | <query>
  nb move (<notebook>:<folder-path>/<id> | <filename> | <title>)
          (<notebook>:<path> | --reset | --to-bookmark | --to-note |
          --to-title | --to-todo) -f | --force
  nb notebooks <name> | <query> --ar | --archived --global --local
               --names --paths --unar | --unarchived
  nb notebooks add (<name> <remote-url> <branch>... | --all) --author
                   --email <email> --name <name>
  nb notebooks (archive | open | peek | status | unarchive) <name>
  nb notebooks author <name> | <path> --email <email> --name <name>
  nb notebooks current --path | --selected | --filename <filename>
                       --global | --local
  nb notebooks delete <name> -f | --force
  nb notebooks (export <name> <path> | import <path>)
  nb notebooks init <path> <remote-url> <branch> --author
                    --email <email> --name <name>
  nb notebooks rename <old-name> <new-name>
  nb notebooks select <selector>
  nb notebooks show (<name> | <path> | <selector>) --ar | --archived
                    --escaped | --name | --path | --filename <filename>
  nb notebooks use <name>
  nb open (<notebook>:<folder-path>/<id> | <filename> | <title>)
  nb peek (<notebook>:<folder-path>/<id> | <filename> | <title>)
  nb pin  (<notebook>:<folder-path>/<id> | <filename> | <title>)
  nb plugins <name> --paths
  nb plugins install <path> | <url> --force
  nb plugins uninstall <name> --force
  nb remote branches <url> | remove | rename <branch-name> <name>
  nb remote delete <branch-name> | reset <branch-name>
  nb remote set <url> <branch-name>
  nb run <command> <arguments>...
  nb search (<notebook>:<folder-path>/<id> | <filename> | <title>)
            <query>... -a | --all --and <query> --not <query> --or <query>
            -l | --list --path -t <tag1>,<tag2>... | --tag <tag1>,<tag2>...
            -t | --tags --type <type> | --<type> --utility <name>
  nb set <name> <value> | <number> <value>
  nb settings colors <number> | themes | edit | list --long
  nb settings (get | show | unset) (<name> | <number>)
  nb settings set (<name> | <number>) <value>
  nb shell <subcommand> <options>... | --clear-history
  nb show (<notebook>:<folder-path>/<id> | <filename> | <title>)
          -a | --added | --authors | -b | --browse | --filename | --id |
          --info-line | --path | -p | --print | --relative-path | -r |
          --render | --title | --type <type> | -u | --updated --no-color
  nb show <notebook>
  nb status <notebook>
  nb subcommands add <name>... alias <name> <alias>
                 describe <name> <usage>
  nb sync -a | --all
  nb tasks (<notebook>:<folder-path>/<id> | <filename> | <description>)
           open | closed
  nb todo add <notebook>:<folder-path>/<filename> <title>
              --description <description> --due <date>
              -r (<url> | <selector>) | --related (<url> | <selector>)
              --tags <tag1>,<tag2>... --task <title>...
  nb todo do   (<notebook>:<folder-path>/<id> | <filename> | <description>)
               <task-number>
  nb todo undo (<notebook>:<folder-path>/<id> | <filename> | <description>)
               <task-number>
  nb todos <notebook>:<folder-path>/ open | closed --pager
               --tags <tag1>,<tag2>...
  nb todos tasks (<notebook>:<folder-path>/<id> | <filename> | <description>)
                 open | closed --pager
  nb unarchive <notebook>
  nb undo (<notebook>:<folder-path>/<id> | <filename> | <title>)
          <task-number>
  nb unpin (<notebook>:<folder-path>/<id> | <filename> | <title>)
  nb unset (<name> | <number>)
  nb update
  nb use <notebook>
  nb -h | --help | help <subcommand> | --readme
  nb -i | --interactive <subcommand> <options>...
  nb --no-color
  nb --version | version

Subcommands:
  (default)    List notes and notebooks. This is an alias for `nb ls`.
               When a <url> is provided, create a new bookmark.
  add          Add a note, folder, or file.
  archive      Archive the current or specified notebook.
  bookmark     Add, open, list, and search bookmarks.
  browse       Browse and manage linked items in terminal and GUI browsers.
  completions  Install and uninstall completion scripts.
  copy         Copy or duplicate an item.
  count        Print the number of items in a notebook or folder.
  delete       Delete a note.
  do           Mark a todo or task as done.
  edit         Edit a note.
  env          Print environment information and install dependencies.
  export       Export a note to a variety of different formats.
  folders      Add, delete, and list folders.
  git          Run `git` commands within the current notebook.
  help         View help information for the program or a subcommand.
  history      View git history for the current notebook or a note.
  import       Import a file into the current notebook.
  init         Initialize the first notebook.
  list         List notes in the current notebook.
  ls           List notebooks and notes in the current notebook.
  move         Move or rename a note.
  notebooks    Manage notebooks.
  open         Open a bookmarked web page or notebook folder, or edit a note.
  peek         View a note, bookmarked web page, or notebook in the terminal.
  pin          Pin an item so it appears first in lists.
  plugins      Install and uninstall plugins and themes.
  remote       Configure the remote URL and branch for the notebook.
  run          Run shell commands within the current notebook.
  search       Search notes.
  settings     Edit configuration settings.
  shell        Start the `nb` interactive shell.
  show         Show a note or notebook.
  status       Print notebook status information.
  subcommands  List, add, alias, and describe subcommands.
  sync         Sync local notebook with the remote repository.
  tasks        List tasks in todos, notebooks, folders, and other items.
  todo         Manage todos and tasks.
  unarchive    Unarchive the current or specified notebook.
  undo         Mark a todo or task as not done.
  unset        Return a setting to its default value.
  unpin        Unpin a pinned item.
  update       Update `nb` to the latest version.
  use          Switch to a notebook.
  version      Display version information.

Notebook Usage:
  nb <notebook>:<subcommand> <identifier> <options>...
  nb <subcommand> <notebook>:<identifier> <options>...

Program Options:
  -h, --help          Display this help information.
  -i, --interactive   Start the `nb` interactive shell.
  --no-color          Print without color highlighting.
  --version           Display version information.

More Information:
  https://github.com/xwmx/nb

Sponsor & Donate:
  https://github.com/sponsors/xwmx
  https://paypal.me/WilliamMelody

Created By:
  William Melody
  https://github.com/xwmx
  https://www.williammelody.com

Contributors:
  https://github.com/xwmx/nb/graphs/contributors
```
