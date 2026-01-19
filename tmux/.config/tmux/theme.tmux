#!/usr/bin/env bash
# AstroJupiter colors for Tmux - 超柔和低亮护眼版（红色超艳 + CPU/RAM 紧凑布局 + 箭头分割）

set -g mode-style "fg=#FF3D3D,bg=#D9D0C8"
set -g message-style "fg=#FF3D3D,bg=#D9D0C8"
set -g message-command-style "fg=#FF3D3D,bg=#D9D0C8"
set -g pane-border-style "fg=#D9D0C8"
set -g pane-active-border-style "fg=#FF3D3D"

set -g status "on"
set -g status-justify "left"
set -g status-style "fg=#FF3D3D,bg=#D0C8C0"
set -g status-left-length "100"
set -g status-right-length "120" # 紧凑后不需要太长
set -g status-left-style NONE
set -g status-right-style NONE

set -g status-interval 10

# 左侧不变
set -g status-left "#[fg=#FFF0F0,bg=#FF3D3D,bold] #S #[fg=#FF3D3D,bg=#D0C8C0,nobold,nounderscore,noitalics]"

set -g status-right "#[fg=#cf9440,bg=#D0C8C0]\
#[fg=#d8d9c7,bg=#cf9440] #[fg=#505459,bg=#D0C8C0]#(cat <(grep '^cpu ' /proc/stat) <(sleep 1 && grep '^cpu ' /proc/stat) | awk -v RS='' '{printf \" %.0f%% \", ($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5)}')\
#[fg=#559a44,bg=#D0C8C0]\
#[fg=#d8d9c7,bg=#559a44]󰊚 #[fg=#505459,bg=#D0C8C0]#(free | awk '/Mem:/ {printf \" %.0f%% \", $3*100/$2}')\
#[fg=#FF3D3D,bg=#D0C8C0]\
#[fg=#FFF0F0,bg=#FF3D3D,bold]#h"
# 
# 窗口状态不变
setw -g window-status-activity-style "underscore,fg=#9C8A82,bg=#D0C8C0"
setw -g window-status-separator ""
setw -g window-status-style "NONE,fg=#9C8A82,bg=#D0C8C0"
setw -g window-status-format "#[fg=#D0C8C0,bg=#D0C8C0,nobold,nounderscore,noitalics]#[default] #I  #W#F #[fg=#D0C8C0,bg=#D0C8C0,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=#D9D0C8,bg=#C0B8B0,nobold,nounderscore,noitalics]#[fg=#FF3D3D,bg=#C0B8B0,bold] #I  #W#F #[fg=#C0B8B0,bg=#D0C8C0,nobold,nounderscore,noitalics]"

# prefix highlight
set -g @prefix_highlight_output_prefix "#[fg=#7A2F00]#[bg=#D0C8C0]#[fg=#D0C8C0]#[bg=#FF3D3D]"
set -g @prefix_highlight_output_suffix ""
