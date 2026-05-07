# active-coding-rules

[English README](README.md)

`active-coding-rules` 是一个 Codex Skill，用一组小而实用的编码规则，把代理的行为约束打包成一个可安装、可复用的技能。

它的目标很直接：让编码代理更少凭空假设，更快进入验证闭环，更少过度设计，也更少做与任务无关的改动。

这个仓库将受 Karpathy 风格启发的编码守则整理为一个可以安装到 Codex skills 目录下的结构，方便在日常开发中直接复用。

## 这个 Skill 能做什么

这个 skill 主要推动代理遵循四种行为：

- **先思考再编码**：在动手前先暴露假设和歧义。
- **优先简单方案**：只用满足当前问题的最小实现。
- **外科手术式修改**：控制 diff 范围，避免顺手重构。
- **目标驱动执行**：先定义成功标准，再用最贴近的方式验证。

落实到实际开发里，代理会更倾向于：

- 先阅读本地代码，再决定方案
- 当歧义会影响实现时，明确说明假设或提出澄清
- 避免为未来假设提前加入抽象和灵活性
- 产出更小、更容易 review 的修改
- 在宣布完成之前先跑聚焦验证
- 在 review 模式下给出更具体、更可执行的问题清单

## 适合谁使用

如果你希望编码代理更像一个有纪律的资深工程师，而不是一个只会补全代码的工具，这个 skill 就适合你。

它尤其适合下面这些诉求：

- 保持 PR 小而清晰，便于评审
- 降低实现过程中的隐含假设
- 减少无必要的重写和重构
- 强制每一步修改都带验证闭环
- 让代码审查输出更具体、更可执行

## 语言适用范围

这是一个**语言无关的行为型 skill**。

它适用于 Python、TypeScript、JavaScript、Go、Rust、Java、C 和 C++，因为它改变的是代理的工作方式，而不是只约束语法。

对于 C 和 C++，这个 skill 很有帮助，但它**不能替代**语言专属的工程规范。你仍然应该配合现有工具链和检查手段一起使用，例如：

- CMake、Ninja、Make 或项目已有的构建系统
- 编译器 warning 和标准版本选项
- 单元测试和集成测试
- ASan、UBSan 等 sanitizer
- 项目已有的静态分析和格式化规则

## 快速开始

### 1. 克隆或下载仓库

把这个仓库放到你希望长期维护的本地位置。

### 2. 使用安装脚本安装 skill

仓库内提供了一个 `install.sh`，它会在你的 Codex skills 父目录下创建一个名为 `active-coding-rules` 的软链接。

示例：

```bash
chmod +x install.sh
./install.sh -path "$HOME/.codex/skills"
```

注意：

- 传入的是 **skills 的父目录**
- 不要自己在路径后面追加 `/active-coding-rules`
- 脚本会自动为你创建软链接

比如，如果你的 skills 通常安装在：

```bash
$HOME/.codex/skills/
```

那么正确命令就是：

```bash
./install.sh -path "$HOME/.codex/skills"
```

### 3. 验证安装结果

安装后，你应该能在 skills 目录下看到类似这样的软链接：

```bash
ls -l "$HOME/.codex/skills/active-coding-rules"
```

如果 skill 已经安装过，而且链接目标就是当前仓库，安装脚本会直接成功退出，并提示 already installed。

## 如何使用

在支持显式 skill 调用的环境中，可以直接在 prompt 里引用这个 skill。

示例：

```text
$active-coding-rules fix the failing test in src/parser.cpp and verify with the narrowest command.
```

```text
$active-coding-rules review this patch and list concrete findings ordered by severity.
```

```text
$active-coding-rules refactor this function without changing behavior, then tell me exactly what you verified.
```

```text
$active-coding-rules debug this crash, reproduce it first, make the smallest fix, and avoid unrelated cleanup.
```

## 预期行为

应用这个 skill 后，代理通常会更倾向于按照下面的循环工作：

1. 明确目标、约束和预期行为。
2. 在决定方案前先检查本地代码。
3. 当歧义会影响实现时，明确写出关键假设。
4. 做满足需求的最小改动。
5. 使用最相关的测试、构建、lint 或手工检查来验证。
6. 汇报改了什么、验证了什么、还剩哪些风险。

在日常使用里，这通常意味着：

- 更少的大范围猜测式重写
- 更少的隐含假设
- 更少没有验证就声称完成的情况
- 更小、更清晰的 diff
- 更具体、更有操作性的 review 输出

## 什么时候适合使用

这个 skill 很适合作为以下任务的默认行为约束：

- bug 修复
- 需要保持行为不变的重构
- 调试含糊或复杂的问题
- 代码审查
- 小到中等规模的功能开发
- 对验证质量要求较高的任务

它不适合作为以下场景的唯一指导：

- 语言专属的架构决策
- 框架专属的工程约定
- 平台专属的构建与发布流程
- 需要额外领域规则的专业场景

## 仓库结构

```text
.
├── README.md
├── README.zh-CN.md
├── install.sh
└── active-coding-rules/
    ├── SKILL.md
    ├── agents/
    │   └── openai.yaml
    └── references/
        ├── core-rules.md
        └── karpathy-examples.md
```

关键文件说明：

- `active-coding-rules/SKILL.md`：skill 主定义和运行规则
- `active-coding-rules/references/core-rules.md`：适合非平凡任务的扩展检查清单
- `active-coding-rules/references/karpathy-examples.md`：用于校准行为预期的示例和反例
- `install.sh`：把 skill 软链接到 skills 目录的安装脚本

## 本地开发

由于安装方式是软链接，所以你在仓库里修改 skill 文件后，已安装的 skill 会立刻反映这些变化。

也就是说，通常你**不需要重新安装**，除非你删除或移动了这个软链接。

## 校验 Skill

如果你的本地 Codex 环境提供了校验脚本，可以运行：

```bash
python "$HOME/.codex/skills/.system/skill-creator/scripts/quick_validate.py" active-coding-rules
```

如果你的校验脚本安装在别的路径，按实际环境调整即可。

## 卸载

如果要移除安装后的 skill，直接删除 skills 目录下的软链接：

```bash
rm -f "$HOME/.codex/skills/active-coding-rules"
```

这个操作只会删除安装出来的链接，不会删除仓库本身。

## FAQ

### 我传的是最终 skill 目录，还是父目录？

传父目录。

正确：

```bash
./install.sh -path "$HOME/.codex/skills"
```

错误：

```bash
./install.sh -path "$HOME/.codex/skills/active-coding-rules"
```

### 改了 skill 文件以后需要重新安装吗？

通常不需要。安装出来的是指向当前仓库的软链接。

### 如果目标路径已经存在会怎样？

- 如果已有软链接本来就指向当前仓库，安装会成功并提示 already installed
- 如果已有软链接指向别处，脚本会报错退出
- 如果该位置已经有普通文件或目录，脚本也会报错退出

## 来源与设计意图

这个仓库将本地 `andrej-karpathy-skills` 项目中可复用的指导内容移植为 Codex Skill 结构，并刻意去掉了 Claude/Cursor 专属安装文件和嵌套 `.git` 数据。

这个仓库的目标不是提供一个庞大的框架，而是为编码代理提供一套小而实用、可以复用的工作纪律。