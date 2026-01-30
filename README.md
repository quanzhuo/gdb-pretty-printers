# gdb-pretty-printers

这个仓库用于收集/维护多套第三方库的 GDB Python pretty printers。

## 使用方式

推荐用 `source` 方式加载（会自动把仓库根目录加入 `sys.path` 并注册 printers）：

```gdb
(gdb) source /abs/path/to/gdb-pretty-printers/scripts/gdb_pretty_printers.py
```

或写到 `~/.gdbinit` / 项目 `.gdbinit`：

```gdb
source /abs/path/to/gdb-pretty-printers/scripts/gdb_pretty_printers.py
```

默认会尝试注册所有可用库的 printers；也可以在 GDB 的 Python 里按需注册：

```gdb
(gdb) python
> import gdb_pretty_printers as gpp
> gpp.register_qt5()
> end
```

## 已支持（初版）

- Qt5: `QString`, `QByteArray`, `QVariant`（尽量兼容不同 Qt5 小版本/构建，但依赖调试信息；无法识别布局时会降级显示指针/长度等摘要）。

## 目录结构

- `gdb_pretty_printers/`: Python 包（按库/版本分目录）
