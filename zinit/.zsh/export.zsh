# ===============================================================
# 环境变量配置 (WSL 稳定版)
# ===============================================================

# --- 1. 声明唯一性绑定 (Zsh 黑科技) ---
# -U 代表 Unique（自动去重），-T 代表 Tie（将数组与环境变量绑定）
# 这样操作 path 数组就等同于操作 PATH 字符串，且不会重复
typeset -gUx path PATH
typeset -gUx fpath FPATH
typeset -gUx ld_library_path LD_LIBRARY_PATH
typeset -gUx pkg_config_path PKG_CONFIG_PATH
typeset -gUx cplus_include_path CPLUS_INCLUDE_PATH
typeset -gUx library_path LIBRARY_PATH

# --- 2. 批量设置路径 (最稳的数组写法) ---
# 优先级从上到下，最上面的路径在 PATH 中最靠前
path=(
    "/usr/lib/wsl/lib"                 # WSL 驱动路径优先
    "$HOME/.local/bin"
    "$HOME/.local/share/nvim/mason/bin"
    "$HOME/.rustup/toolchains/esp/riscv32-esp-elf/esp-15.2.0_20250920/riscv32-esp-elf/bin/"
    # "$HOME/.bun/bin"
    "$HOME/.cargo/bin"
    # "$HOME/.dotnet"
    # "$HOME/tools/renode"
    $path                              # 保留原有的其他路径
)

# --- 3. 设置链接与编译路径 ---
ld_library_path=(
    "/usr/lib/wsl/lib"
    "$HOME/.local/lib64"
    $ld_library_path
)

library_path=(
    "$HOME/.local/lib64"
    "$HOME/.local/lib"
    $library_path
)

cplus_include_path=(
    "$HOME/.local/include"
    $cplus_include_path
)

pkg_config_path=(
    "$HOME/.local/lib64/pkgconfig"
    $pkg_config_path
)

# --- 4. 显卡与显示配置 (WSL2 专用) ---
export GALLIUM_DRIVER=d3d12
export LIBVA_DRIVER_NAME=d3d12
export ZED_ALLOW_EMULATED_GPU=1
export DISPLAY=:0

# --- 5. 其他静态变量 ---
export UV_DEFAULT_INDEX="https://pypi.tuna.tsinghua.edu.cn/simple"
# export TRANS_DEFAULT_TARGET_LANGUAGE="zh"

# 解决一些工具在 WSL 里的显示问题
# export QT_QPA_PLATFORM=xcb 2>/dev/null
