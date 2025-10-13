# export TRANS_DEFAULT_TARGET_LANGUAGE="zh"
#
append_env() {
    local var_name="$1"
    local value="$2"
    local delimiter="${3:-:}"
    
    # 使用eval来获取变量的当前值
    local current_value=$(eval echo \$${var_name})
    
    # 检查变量是否已存在且非空
    if [ -n "$current_value" ]; then
        # 变量存在，追加值
        eval export ${var_name}=\"${current_value}${delimiter}${value}\"
    else
        # 变量不存在或为空，直接设置
        eval export ${var_name}=\"${value}\"
    fi
}

# 添加路径
append_env "CPLUS_INCLUDE_PATH" "$HOME/.local/include"
append_env "LIBRARY_PATH" "$HOME/.local/lib64"
append_env "LIBRARY_PATH" "$HOME/.local/lib"

# add_to_env_var "LD_LIBRARY_PATH" "$HOME/.local/lib64"
append_env "PKG_CONFIG_PATH" "$HOME/.local/lib64/pkgconfig"
append_env "LD_LIBRARY_PATH" "$HOME/.local/lib64"

append_env "PATH" "$HOME/.local/bin"
append_env "PATH" "$HOME/.local/share/nvim/mason/bin"
append_env "PATH" "$HOME/.bun/bin"
append_env "PATH" "$HOME/.cargo/bin"
append_env "PATH" "$HOME/.dotnet"
append_env "PATH" "$HOME/tools/renode/"

# export GTK_IM_MODULE=fcitx
# export QT_IM_MODULE=fcitx
# export XMODIFIERS=@im=fcitx
# export INPUT_METHOD=fcitx

# export QEMU_LD_PREFIX=/usr/riscv64-linux-gnu:$QEMU_LD_PREFIX
# export QEMU_LD_PREFIX=/home/tll/tools/riscv/sysroot
export PATH="/usr/lib/wsl/lib:$PATH"
export LD_LIBRARY_PATH="/usr/lib/wsl/lib:$LD_LIBRARY_PATH"
# 图像显示
export ZED_ALLOW_EMULATED_GPU=1
# export GALLIUM_DRIVER=d3d12
# export MESA_LOADER_DRIVER_OVERRIDE=d3d12
export DISPLAY=:0
# export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA
