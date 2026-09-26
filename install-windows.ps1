# 职场办公模式 —— DeepSeek Harness Agent 预设安装脚本（Windows）
#
# 用法：在本文件所在目录执行下面任意一种
#     1) 右键本文件 → 「使用 PowerShell 运行」
#     2) powershell -ExecutionPolicy Bypass -File install-windows.ps1
#
# 重要说明（维护者看）：
#   * 本文件必须保存为 **UTF-8 with BOM**。Windows PowerShell 5.1 在没有 BOM 时
#     会按系统 ANSI（中文系统是 GBK）解码脚本，中文字符串会被解成乱码，
#     进而引发莫名其妙的语法错误（比如"字符串缺少结束符"）。
#   * 路径一律用**单引号**字符串。双引号里反斜杠是转义字符，
#     'skills\office-writing' 这种写法用双引号会把 \o 当转义，导致内容错乱。

$ErrorActionPreference = 'Stop'

Write-Host '=========================================================='
Write-Host '  安装 DeepSeek Harness 预设：职场办公模式'
Write-Host '=========================================================='
Write-Host ''

# ---- 1. 本脚本所在目录（就是预设内容所在处）----
$source = $PSScriptRoot
$compositionFile = Join-Path $source 'agent.cordis.yml'
if (-not (Test-Path $compositionFile)) {
    Write-Host '[错误] 当前目录里找不到 agent.cordis.yml' -ForegroundColor Red
    Write-Host '       请把完整的预设文件夹解压后再运行本脚本。'
    Write-Host ('       当前目录：' + $source)
    exit 1
}
Write-Host ('  预设来源：' + $source)

# ---- 2. 找 DSH 主目录 ----
# 优先用 DSH_HOME 环境变量；没有就用默认的用户目录下的 .dsh
$dshHome = $env:DSH_HOME
if ([string]::IsNullOrWhiteSpace($dshHome)) {
    $dshHome = Join-Path $env:USERPROFILE '.dsh'
    Write-Host '  未设置 DSH_HOME，使用默认位置。'
} else {
    Write-Host ('  检测到 DSH_HOME：' + $dshHome)
}

if (-not (Test-Path $dshHome)) {
    Write-Host ('[错误] 找不到 DSH 主目录：' + $dshHome) -ForegroundColor Red
    Write-Host '       请确认已安装 DeepSeek Harness。'
    Write-Host '       如果装在别处，请先设置环境变量 DSH_HOME 再运行本脚本。'
    exit 1
}

# ---- 3. 目标位置 ----
$presetRoot = Join-Path $dshHome '.agent-presets'
$target = Join-Path $presetRoot 'office-work'
Write-Host ('  安装目标：' + $target)
Write-Host ''

# 已经装过就先备份，避免直接覆盖用户自己的改动
if (Test-Path $target) {
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backup = $target + '.bak-' + $stamp
    Write-Host '  检测到已安装的旧版本，先备份到：' -ForegroundColor Yellow
    Write-Host ('    ' + $backup)
    Move-Item -Path $target -Destination $backup
}

# ---- 4. 复制 ----
# 只复制预设真正需要的三样东西，避免把 .git、README 之类也塞进去
New-Item -ItemType Directory -Force -Path $presetRoot | Out-Null
New-Item -ItemType Directory -Force -Path $target | Out-Null

$items = @('agent.cordis.yml', 'preset.yml', 'skills')
foreach ($item in $items) {
    $from = Join-Path $source $item
    if (Test-Path $from) {
        Copy-Item -Path $from -Destination $target -Recurse -Force
        Write-Host ('  + ' + $item)
    } else {
        Write-Host ('  ! 缺少 ' + $item + '（可能影响预设加载）') -ForegroundColor Yellow
    }
}

# ---- 5. 校验装好了 ----
Write-Host ''
$ok = $true
$mustHave = @('agent.cordis.yml', 'preset.yml', 'skills\office-writing\SKILL.md')
foreach ($must in $mustHave) {
    $p = Join-Path $target $must
    if (Test-Path $p) {
        Write-Host ('  [OK] ' + $must)
    } else {
        Write-Host ('  [缺失] ' + $must) -ForegroundColor Red
        $ok = $false
    }
}

Write-Host ''
Write-Host '=========================================================='
if ($ok) {
    Write-Host '  安装完成！' -ForegroundColor Green
    Write-Host '=========================================================='
    Write-Host ''
    Write-Host '  接下来：'
    Write-Host '    1. 重启 DeepSeek Harness（预设是启动时读取的）'
    Write-Host '    2. 新建会话时，在预设列表里选择「职场办公模式」'
    Write-Host ''
} else {
    Write-Host '  安装不完整，请检查上面的 [缺失] 项。' -ForegroundColor Red
    Write-Host '=========================================================='
    exit 1
}
