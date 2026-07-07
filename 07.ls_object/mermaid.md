```mermaid
classDiagram
  class Entry {
    +name()
    +type_char()
    +permission_string()
    +nlink()
    +owner()
    +group()
    +size()
    +mtime()
    +blocks()
    -path
    -stat
  }

  class EntryList {
    +build_entries(dir_path, show_hidden)
    +sorted_entries(reverse)
    -entries
  }

  class Options {
    +a?()
    +r?()
    +l?()
    -options
  }

  class Printer {
    +print_in_column(entries)
    +max_width(entries, field)
    +total_blocks(total_entries)
    +print_in_detail(entries)
  }

  EntryList --> Entry : 複数保持
  Printer --> Entry : 利用
```
