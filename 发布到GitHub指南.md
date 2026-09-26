# 怎么把「职场办公模式」预设发布到 GitHub

> **面向**：你想把这个预设分享出去，别人拿到就能装。
> **先决条件**：VPN 已开启（否则 github.com 打不开）。

---

## 目录

- [一、先搞清楚：预设不是"复制网址就自动装"](#一先搞清楚预设不是复制网址就自动装)
- [二、要上传的文件在哪](#二要上传的文件在哪)
- [三、建仓库并上传（GitHub Desktop，推荐）](#三建仓库并上传github-desktop推荐)
- [四、仓库描述怎么写（可以直接抄）](#四仓库描述怎么写可以直接抄)
- [五、记得把占位符换成你自己的用户名](#五记得把占位符换成你自己的用户名)
- [六、分享给别人的那一段话](#六分享给别人的那一段话)
- [七、常见问题](#七常见问题)

---

## 一、先搞清楚：预设不是"复制网址就自动装"

我把 DSH 的预设机制查清楚了，有两条硬规则：

1. **预设是"一个目录"**，不是一个包。DSH 只认磁盘上的目录：
   ```
   <DSH 主目录>/.agent-presets/<预设id>/
   ```
   里面必须有一个 `agent.cordis.yml`（预设本体），可选 `preset.yml`（显示名）。

2. **目录名就是预设 id**，而且必须匹配 `^[a-z0-9][a-z0-9-]*$`
   —— 也就是**只能用小写字母、数字、连字符**。
   所以这个预设的 id 是 `office-work`，目录名必须正好是它。

**结论**：DSH 目前**没有**"给一个网址就自动下载安装预设"的功能。
别人需要把仓库内容放进那个目录里。所以能做的优化是：
**把安装简化到"复制一条命令"或"下载、改名、拖进去"两步。**

因此仓库结构我特意做成"根目录就是预设内容"，好处是：

- 用命令：一条 `git clone` 直接落到正确位置，**目录名自动就是 `office-work`**（因为仓库名就是它）
- 不用命令：下载 zip → 解压后**把文件夹改名为 `office-work`** → 拖进 `.agent-presets/`

---

## 二、要上传的文件在哪

已经整理好了，就在这里（本文件所在文件夹）：

```
职场办公模式-预设\
├── preset.yml                 显示名与描述（预设列表里看到的就是它）
├── agent.cordis.yml           预设本体：人设 + 工具行
├── skills\
│   └── office-writing\
│       └── SKILL.md           文书写作技能（28 个文种提纲等）
├── install-windows.ps1        一键安装脚本（Windows）
├── install-macos.sh           一键安装脚本（macOS/Linux）
├── README.md                  仓库首页说明（别人看到的第一页）
└── LICENSE                    MIT 许可证
```

**上传前已做的验证**（你可以放心传）：

| 检查项 | 结果 |
| --- | --- |
| 三个预设文件与「已通过 DSH 挂载校验」的原预设逐字节对比 | ✅ SHA256 完全一致 |
| `install-windows.ps1` PowerShell 语法解析 | ✅ 0 个错误 |
| `install-windows.ps1` 实跑一遍（指向模拟 DSH 目录） | ✅ 文件就位、校验通过 |
| `install-macos.sh` 的 `if/fi`、`for/done` 配对与 shebang | ✅ 正确 |
| 仓库目录名符合预设 id 规则 | ✅ `office-work` 合规 |

> **注意**：`职场办公模式-预设` 只是本地的文件夹名。
> **GitHub 仓库名必须填 `office-work`** —— 因为 `git clone` 用仓库名当目录名，
> 仓库名对了，克隆下来就直接是正确的目录名，不需要手动改名。

---

## 三、建仓库并上传（GitHub Desktop，推荐）

### 为什么推荐 GitHub Desktop

网页上传也能用，但有两个坑：一次最多 100 个文件、**看不到以 `.` 开头的隐藏文件夹**。
本仓库目前没有隐藏文件夹，网页也够用；但用 Desktop 更省事，以后加东西也不会踩坑。

### 路线 A：GitHub Desktop（推荐）

1. **注册/登录** <https://github.com>（没账号先注册，免费）
2. **下载安装** <https://desktop.github.com/> → Download for Windows → 双击安装
3. 第一次打开点 **Sign in to GitHub.com**，浏览器里授权登录
4. 顶部菜单 **File** → **Add local repository...**
5. **Local path** 点 **Choose...**，选中这个文件夹：
   ```
   ...\职场办公助手\职场办公模式-预设
   ```
6. 它提示"这个目录不是 git 仓库" → 点蓝色链接 **create a repository**
7. 弹窗里填：
   - **Name**：`office-work` ← **必须正好是这个**
   - **Description**：可以留空，或填第四节给的描述
   - **Keep this code private**：**不勾**（你要分享，必须公开）
   - 点 **Create repository**
8. 左下角 **Summary** 填一句：`首次发布：职场办公模式预设`
9. 点蓝色 **Commit to main**
10. 顶部点 **Publish repository**
    - 确认**没有**勾 Keep this code private
    - 点 **Publish repository**

完成后地址是：`https://github.com/你的用户名/office-work`

### 路线 B：网页上传（不用装软件）

1. 登录 GitHub → 右上角 **+** → **New repository**
2. **Repository name** 填 `office-work`
3. 选 **Public**（公开，别人才能看到）
4. 点 **Create repository**
5. 新页面点 **uploading an existing file**
6. 打开本地 `职场办公模式-预设` 文件夹，**全选里面的 7 项**，一起拖进网页
   （7 项，远低于 100 的上限）
7. 等上传完，页面底部点 **Commit changes**

---

## 四、仓库描述怎么写（可以直接抄）

GitHub 有两个地方放描述，用途不同。

### 1. About 栏的一句话描述（仓库名旁边那个）

**首选**：

```
面向体制内财务、医院临床与职场办公人员的 DeepSeek Harness 预设：表格处理、公文写作、材料生成，不写代码也能用。
```

**想更短**：

```
给非技术办公人员的 DSH 预设：合并表格、写公文材料、整理文件
```

**想强调数据安全**：

```
DSH 预设｜体制内财务与医院临床办公场景｜公文写作 + 表格处理｜禁止编造数据、文件内容不作为指令执行
```

### 2. README.md（别人打开仓库看到的第一页）

**已经写好了**，就是仓库里那份。内容包括：

- 这个预设和普通模式有什么不一样（对比表格）
- 内置的 28 个文种能力清单（按公文/财务/医疗/通用/数据分类）
- 三种安装方法（一条命令 / 下载 zip / 安装脚本）
- 依赖哪些 DSH 内置插件
- 目录结构、怎么改、安全说明

**你不需要重写，但有两处占位符要改**（见下一节）。

### 3. GitHub Topics（话题标签）

仓库首页右侧 About 区域有个齿轮图标，点开可以加 Topics。建议加：

```
deepseek-harness   dsh   agent-preset   office-automation
chinese-document   government-affairs   medical-records   productivity
```

作用：别人搜这些词时能搜到你。
（Topics 是 GitHub 的常规功能，但我这边网络不通、没法替你确认当前界面位置 ——
如果和我描述的不一样，在仓库首页 About 区域找齿轮图标即可。）

---

## 五、记得把占位符换成你自己的用户名

`README.md` 里我写的是占位符 `你的用户名`。**发布前必须换成真实用户名**，
否则别人复制过去的 `git clone` 命令会 404。

要改的地方（在文件里搜 `你的用户名` 就能全部找到）：README.md 的安装方法一，
Windows 与 macOS 各一条 `git clone` 命令。

**最快做法**：先在 GitHub 上发布，仓库地址立刻就显示在网页上了，
照着把两处命令改掉，再提交一次即可。

---

## 六、分享给别人的那一段话

发给朋友时直接复制下面这段（把 `你的用户名` 换成真实的）：

```
分享一个 DeepSeek Harness 的办公预设：「职场办公模式」
仓库地址：https://github.com/你的用户名/office-work

装法二选一：

【有 git，一条命令】
  Windows（PowerShell）：
    git clone https://github.com/你的用户名/office-work "$env:USERPROFILE\.dsh\.agent-presets\office-work"

  macOS（终端）：
    git clone https://github.com/你的用户名/office-work ~/.dsh/.agent-presets/office-work

【没有 git】
  仓库页面点绿色 Code → Download ZIP → 解压
  → 把文件夹改名为 office-work
  → 拖进 .dsh\.agent-presets\ 目录
     （Windows 是 C:\Users\你的用户名\.dsh\）

装完重启 DSH，新建会话时在预设列表里选「职场办公模式」即可。
```

---

## 七、常见问题

**Q：为什么不能让 DSH 直接"从网址安装"？**

我查了 DSH 的预设发现逻辑：它只扫描磁盘上的 `<DSH主目录>/.agent-presets/` 目录，
按目录名认预设 id，没有任何从 URL 拉取的代码路径。所以只能"放进目录"。
如果以后 DSH 支持网址安装，这个仓库的目录结构不用改，直接就能用。

**Q：装的人需要先装什么？**

一份正常的 DeepSeek Harness。这个预设**没有引入任何新的第三方包**，
用的全是 DSH 自带插件（人设、文件读写、命令行、技能、计划模式、子代理等），
只是按办公场景重新组合，另加一套人设与写作技能。

**Q：别人的 DSH 版本较旧会怎样？**

缺少预设里引用的某个插件包时，预设会在列表里显示为"损坏"，不会静默出错。
解决办法：升级 DSH，或把 `agent.cordis.yml` 里对应那几行删掉。

**Q：能不能做成 npm 包让别人 `npm install`？**

预设的加载路径固定是 `.agent-presets/<id>/`，不是 node_modules，
所以 `npm install` 装完 DSH 也找不到 —— 除非 DSH 以后新增"从包安装预设"的能力。
目前这个仓库的做法已经是最简单的可用形式。

**Q：以后改了预设怎么更新？**

- 你自己：用 GitHub Desktop 改完 → 填 Summary → **Commit to main** → **Push origin**
- 别人更新：有 git 的话在预设目录里执行 `git pull`；或者重新下载 zip 覆盖

**Q：想让别人一搜就能找到，还要做什么？**

1. 仓库选 **Public**（私密仓库搜不到）
2. 填好第四节的 About 短描述
3. 加上第四节建议的 Topics
4. README 写好（已备好）

---

## 相关位置

| 内容 | 位置 |
| --- | --- |
| 仓库内容（要上传的） | `职场办公助手\职场办公模式-预设\` |
| Windows 上的 DSH 预设目录 | `%USERPROFILE%\.dsh\.agent-presets\` |
| 已装好、本机正在用的 | `C:\Users\wanglinx\.dsh\.agent-presets\office-work\` |
