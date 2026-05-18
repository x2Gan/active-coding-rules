# Matt Skills 吸取融合报告

## 报告目的

本报告总结本仓库从本地 `skills/` 目录中的 Matt Pocock Skills 吸取到的 Agent Skill 工程经验，并说明这些经验如何融合进 `active-coding-rules`。

这份报告面向维护者阅读；面向 agent 后续加载的细化材料放在 `active-coding-rules/references/matt-pocock-skills-lessons.md`。

## 调研范围

重点调研对象：

- `skills/README.md`
- `skills/CLAUDE.md`
- `skills/CONTEXT.md`
- `skills/.claude-plugin/plugin.json`
- `skills/skills/engineering/*`
- `skills/skills/productivity/*`
- `skills/skills/misc/*`
- `skills/docs/adr/*`
- `skills/.out-of-scope/*`

核心关注点：

- Skill 如何拆分和触发
- `SKILL.md` 与 reference 文件如何分工
- 复杂工程任务如何转化为可执行流程
- 如何减少 agent 的常见失败模式
- 哪些内容适合融入 `active-coding-rules`
- 哪些内容不应该直接搬进主技能

## 总体结论

Matt Skills 的核心优势不是单条规则写得更完整，而是把工程纪律拆成一组小而稳定的任务模式。

`active-coding-rules` 当前定位是通用编码行为约束：少假设、少过度设计、窄修改、强验证。它不应该变成一个庞大的工程流程框架。更合适的融合方式是：

- 保持主 `SKILL.md` 轻量；
- 把 Matt Skills 中的深度经验沉淀为 reference；
- 让 agent 在复杂任务中按需加载更具体的模式；
- 逐步增加 diagnosis、TDD、architecture、prototype、brief 等任务模式；
- 避免把 issue tracker、triage、ADR、CONTEXT 文档变成所有任务的硬依赖。

## 已经完成的融合

### 1. 新增深度学习参考文档

新增文件：

```text
active-coding-rules/references/matt-pocock-skills-lessons.md
```

该文档系统整理了 Matt Skills 中值得学习的内容，并给出对 `active-coding-rules` 的适配方式。

覆盖主题包括：

- 小而可组合的 Skill 设计
- 渐进披露结构
- debugging feedback loop
- structured grilling
- `CONTEXT.md` 共享语言
- 轻量 ADR
- TDD 垂直切片
- deep module / seam / adapter 架构语言
- throwaway prototype 纪律
- durable PRD / issue / agent brief
- triage 状态机
- out-of-scope 知识库
- handoff 与 brevity mode 的设计经验
- manifest 与文档一致性
- deterministic scripts 的使用边界

### 2. 更新主 Skill 的 reference 入口

修改文件：

```text
active-coding-rules/SKILL.md
```

在 `References` 中新增：

```text
Read `references/matt-pocock-skills-lessons.md` when evolving this skill or when a complex task needs richer workflows for diagnosis, TDD, architecture, prototypes, planning, or durable agent briefs.
```

这样主 Skill 仍然保持轻量，但后续在复杂任务或继续改造 `active-coding-rules` 时，agent 能发现并加载这份深度材料。

## 值得吸取的核心设计点

### 1. Skill 应该是操作流程，不是知识仓库

Matt 的每个活跃 skill 都围绕一个明确任务：

- `diagnose` 负责疑难 bug 和性能回退；
- `tdd` 负责红绿重构；
- `prototype` 负责抛弃式原型；
- `triage` 负责 issue 状态流转；
- `grill-with-docs` 负责需求澄清和领域语言沉淀；
- `improve-codebase-architecture` 负责架构加深机会。

启发：

`active-coding-rules` 的主入口应该继续保持行为约束，而不是塞入所有细节。复杂流程应进入 reference 或未来拆成独立 task mode。

### 2. 渐进披露是 Agent Skill 的关键结构

Matt Skills 通常采用：

```text
SKILL.md      -> 触发条件和核心流程
*.md          -> 细化模式、模板、术语、边界
scripts/      -> 确定性工具
```

启发：

本仓库应继续采用：

```text
active-coding-rules/SKILL.md
active-coding-rules/references/*.md
active-coding-rules/scripts/*    # 未来需要时再加
```

主文件越短，日常触发成本越低；reference 越清晰，复杂任务越可控。

### 3. Debugging 的第一目标是反馈环

Matt 的 `diagnose` 最有价值的观点是：疑难 bug 的核心不是先解释原因，而是先构造稳定、快速、可重复的 pass/fail signal。

可吸收规则：

- 修 bug 前先复现用户描述的确切症状；
- 如果不能复现，要明确说明尝试过什么和缺什么；
- 对复杂 bug，先列 3-5 个可证伪假设；
- 每次 instrumentation 只验证一个假设；
- debug log 必须带唯一前缀，最后清理；
- 没有合适 regression seam 本身就是架构问题。

### 4. TDD 应该按垂直切片推进

Matt 的 `tdd` 反对水平切片：先写所有测试，再写所有实现。它强调一个行为测试、一点实现、再进入下一轮。

可吸收规则：

- 一个测试验证一个可观察行为；
- 测试通过公开接口，不绑死内部实现；
- mock 只用于系统边界；
- refactor 只能在 green 状态下进行；
- 测试应该能在内部重构后继续成立。

### 5. 架构改进应该追求 deep module

Matt 的架构语言强调：

- Module
- Interface
- Implementation
- Seam
- Adapter
- Depth
- Leverage
- Locality

可吸收规则：

- 不为单次使用添加抽象；
- 但也不能把“简单”误解成永远拒绝抽象；
- 好抽象应增加 locality 或 leverage；
- interface 是测试表面；
- 用 deletion test 判断模块是否只是 pass-through；
- 一个 adapter 多半是假 seam，两个 adapter 才更像真实 seam。

### 6. Shared language 能减少 agent 漂移

Matt 的 `CONTEXT.md` 是领域语言文件，不是实现说明。它记录项目专有术语、避免使用的别名、概念关系和已解决歧义。

可吸收规则：

- 非平凡任务先寻找 `CONTEXT.md`、`CONTEXT-MAP.md`、`docs/adr/`；
- 找不到时安静继续，不强制创建；
- 测试名、issue 标题、架构建议、最终报告应尽量使用项目既有术语；
- 避免为已有概念发明同义词。

### 7. Prototype 必须回答一个问题

Matt 的 `prototype` 强调：原型不是低质量生产代码，而是有边界的学习工具。

可吸收规则：

- 写原型前说明它要回答的问题；
- logic prototype 和 UI prototype 要分开；
- 原型应明显标注为 throwaway；
- 默认不持久化、不加测试、不抽象；
- 结束后捕获结论，然后删除或吸收到正式实现。

### 8. Agent brief 是未来 agent 的合同

Matt 的 `AGENT-BRIEF.md` 强调 durable over precise：任务说明不应该依赖容易过期的文件路径和行号，而应描述行为、接口、验收标准和边界。

可吸收模板：

```text
Current behavior
Desired behavior
Key interfaces
Acceptance criteria
Out of scope
```

这对 `active-coding-rules` 的启发是：当任务变大时，先把任务压成稳定 brief，再执行或交给后续 agent。

## 不应直接吸收的内容

以下内容有价值，但不适合直接塞进 `active-coding-rules/SKILL.md`：

- 完整 issue tracker 设置流程；
- 完整 triage 状态机实现；
- 强制创建 `CONTEXT.md` 或 ADR；
- persistent brevity mode；
- 大量 GitHub / GitLab CLI 细节；
- Matt 个人工作流相关的 personal/in-progress 内容；
- 针对 Claude Code 的 hook 配置细节；
- 课程脚手架、shoehorn 迁移等领域特定 skill。

原因：

`active-coding-rules` 是通用编码纪律，不是项目管理框架或特定工具集。直接吸收会让主 Skill 变重，降低触发质量。

## 对 active-coding-rules 的融合策略

### 当前阶段

当前已采取的策略：

- 主 `SKILL.md` 只增加 reference 链接；
- 完整学习内容放入 `references/matt-pocock-skills-lessons.md`；
- 不增加新硬依赖；
- 不改变默认编码行为；
- 不修改用户下载的 `skills/` 目录。

### 下一阶段建议

建议按使用频率逐步增加以下 reference 文件，而不是一次性拆成多个 skills：

```text
active-coding-rules/references/diagnosis-mode.md
active-coding-rules/references/tdd-mode.md
active-coding-rules/references/architecture-mode.md
active-coding-rules/references/prototype-mode.md
active-coding-rules/references/brief-mode.md
```

每个 mode 控制在 80-150 行左右，只写操作流程和判断标准。

## 待逐步移入的内容提取

本节把未来真正需要迁入 `active-coding-rules` 的内容提取出来。后续即使删除本地 `skills/` 目录，也可以直接以本节为来源，逐步拆成 `references/*.md` 或少量主规则。

### 迁移原则

迁入时遵守以下边界：

- 先进入 `references/`，不要先塞进 `SKILL.md`；
- 只有高频、短小、必须总是生效的规则才进入 `core-rules.md`；
- 每个 reference 只服务一个任务模式；
- 每个模式都要包含触发场景、操作步骤、验证方式、退出条件；
- 不引入 issue tracker、GitHub、GitLab 等工具硬依赖；
- 不强制项目创建 `CONTEXT.md`、ADR 或 `.out-of-scope/`；
- 不复制 Matt 的个人工作流，只吸收可迁移的工程纪律。

### 1. `diagnosis-mode.md`

用途：

复杂 bug、性能回退、非确定性失败、线上和本地行为不一致、用户说 "debug/diagnose/broken/failing/crash/slow" 时加载。

核心规则：

- 先构造反馈环，再解释原因；
- 反馈环必须尽量快、确定、可由 agent 运行；
- 复现必须匹配用户描述的症状；
- 没有复现时，不要直接改代码，除非明确说明风险；
- 先列 3-5 个可证伪假设，再逐个验证；
- 每次 probe 只改变一个变量；
- 临时日志带唯一前缀，例如 `[DEBUG-a1b2]`；
- 修复后必须回跑原始复现和回归测试；
- 无法找到正确 regression seam 时，要把它记录为架构风险。

可迁入流程：

```text
1. Build feedback loop
   - failing test
   - curl / HTTP script
   - CLI fixture
   - browser automation
   - captured trace replay
   - throwaway harness
   - fuzz / property loop
   - bisect / differential loop
   - human-in-the-loop script as last resort

2. Reproduce
   - confirm exact symptom
   - confirm repeatability or raise reproduction rate
   - capture error message, wrong output, or timing baseline

3. Hypothesize
   - list 3-5 ranked hypotheses
   - each hypothesis must predict what would change if true

4. Instrument
   - debugger or REPL first when available
   - targeted logs next
   - no "log everything and grep"

5. Fix
   - convert minimized repro into regression test if a correct seam exists
   - apply smallest fix
   - rerun original feedback loop

6. Cleanup
   - remove debug logs
   - delete throwaway harnesses
   - report correct hypothesis and verification
```

适合加入 `core-rules.md` 的短句：

```text
For hard bugs, build the tightest feedback loop before explaining the cause.
```

### 2. `tdd-mode.md`

用途：

用户要求 TDD、红绿重构、测试优先，或任务风险主要来自行为正确性时加载。

核心规则：

- 不做水平切片；
- 一个行为，一个失败测试，一个最小实现；
- 测试行为，不测实现细节；
- 测试通过公开接口；
- mock 只用于系统边界；
- green 前不 refactor；
- 每轮结束都运行最窄相关测试。

可迁入流程：

```text
1. Identify public behavior
   - name the user/caller-visible behavior
   - identify the smallest meaningful public interface

2. Red
   - write one failing test for one behavior
   - verify it fails for the expected reason

3. Green
   - write only enough code to pass
   - avoid speculative branches and future options

4. Repeat
   - add the next behavior only after current behavior is green

5. Refactor
   - remove duplication
   - deepen modules when useful
   - keep tests at the public interface
   - rerun tests after each refactor step
```

测试判断标准：

```text
Good tests:
- assert observable behavior
- use public APIs
- survive internal refactors
- read like specifications

Bad tests:
- assert internal call counts
- mock internal collaborators
- test private methods
- verify by bypassing the interface
```

适合加入 `core-rules.md` 的短句：

```text
One behavior, one failing test, one minimal implementation slice.
```

### 3. `architecture-mode.md`

用途：

用户要求架构改进、重构设计、降低复杂度、提高可测试性、整理模块边界，或发现“为测试抽了很多薄函数但真实复杂度仍散落在调用方”时加载。

核心词汇：

```text
Module:
Anything with an interface and an implementation.

Interface:
Everything a caller must know to use the module correctly: types, invariants,
ordering, error modes, config, performance expectations.

Implementation:
The code hidden behind the interface.

Seam:
Where behavior can vary without editing the caller in place.

Adapter:
A concrete thing that satisfies an interface at a seam.

Depth:
Leverage at the interface. A deep module hides substantial behavior behind a
small interface.

Leverage:
What callers get from depth.

Locality:
What maintainers get from depth: change, bugs, knowledge, and verification
concentrated in one place.
```

核心规则：

- interface 是测试表面；
- depth 是 interface 的性质，不是代码行数比例；
- deletion test：删除模块后，复杂度是消失了，还是扩散到了多个调用方；
- 单 adapter 通常是假 seam，两个 adapter 才说明 seam 真实存在；
- 好抽象增加 locality 或 leverage；
- 不为“也许以后会变”添加 seam；
- 架构建议先给候选，不要马上写接口。

可迁入流程：

```text
1. Read context
   - inspect relevant code
   - read project glossary/ADR if present

2. Find friction
   - shallow pass-through modules
   - scattered behavior across callers
   - hard-to-test logic
   - seams that leak implementation details
   - tests coupled to internals

3. Present candidates
   - files/modules involved
   - problem
   - proposed direction
   - benefits in locality, leverage, and testing

4. Design only after selection
   - clarify constraints
   - classify dependencies
   - compare interface options
   - recommend one shape
```

依赖分类：

```text
In-process:
Pure computation or in-memory state. Usually easiest to deepen.

Local-substitutable:
DB/filesystem/etc with local test stand-ins. Test through the deep module with
the stand-in.

Remote-owned:
Internal services across a network. Put a port at the seam and use production
and test adapters.

True external:
Third-party services. Inject an interface and use a mock/fake adapter in tests.
```

适合加入 `core-rules.md` 的短句：

```text
Add abstraction only when it increases locality or leverage.
```

### 4. `prototype-mode.md`

用途：

用户想试一个状态模型、数据结构、交互方式、UI 方案、流程可行性，或者说 "prototype / mock up / try a few designs / let me play with it" 时加载。

核心规则：

- prototype 是回答问题的 throwaway code；
- 开始前写明问题；
- logic prototype 和 UI prototype 分开；
- 默认不持久化；
- 默认不加测试；
- 默认不抽象；
- 一条命令可运行；
- 结束后保留结论，删除或吸收代码。

Logic prototype 迁入内容：

```text
Use when the question is about state, data shape, business rules, or legal transitions.

Shape:
- pure reducer
- explicit state machine
- pure functions over plain data
- small state-owning class/module only when needed

TUI:
- render current state on every action
- show keyboard shortcuts
- keep state in memory
- make it easy for user to notice impossible transitions
```

UI prototype 迁入内容：

```text
Use when the question is visual structure or interaction layout.

Rules:
- prefer mounting variants inside an existing page
- use `?variant=` or equivalent route state
- create 3 radically different variants by default
- variants differ in structure, not just color/copy
- add a visible switcher in non-production only
- delete losing variants after a winner is chosen
```

适合加入 `core-rules.md` 的短句：

```text
Prototype code answers a question; production code owns a behavior.
```

### 5. `brief-mode.md`

用途：

任务较大、需要交给后续 agent、需要写 issue/PRD、或者当前对话已经形成明确需求但还没有稳定执行合同。

核心规则：

- durable over precise；
- 写行为和接口，不写行号；
- 写验收标准，不写模糊成功语；
- 明确 out of scope；
- 对未来 agent 友好，而不是对当前文件布局过拟合。

可迁入模板：

```markdown
## Agent Brief

**Category:** bug / enhancement / refactor
**Summary:** one-line description

**Current behavior:**
What happens now.

**Desired behavior:**
What should happen after the work is complete.

**Key interfaces:**
- Type/function/config/user workflow that matters
- What must change semantically

**Acceptance criteria:**
- [ ] Specific, independently verifiable criterion
- [ ] Specific, independently verifiable criterion
- [ ] Specific, independently verifiable criterion

**Out of scope:**
- Adjacent feature that should not be changed
- Cleanup/refactor not required for this task
```

垂直切片规则：

```text
Each implementation issue should deliver a narrow complete path through the
relevant layers and be independently demoable or verifiable.
```

适合加入 `core-rules.md` 的短句：

```text
For substantial work, write current behavior, desired behavior, acceptance criteria, and out of scope before editing.
```

### 6. `context-adr-mode.md`

用途：

需求涉及领域术语、模块命名、长期架构选择、跨上下文关系，或者 agent 明显在用不稳定词汇描述系统。

核心规则：

- `CONTEXT.md` 是 glossary，不是 spec；
- 只记录项目特有术语，不记录通用编程概念；
- 定义要短：说明是什么，不说明怎么实现；
- 记录 aliases to avoid；
- 记录 relationships 和 flagged ambiguities；
- ADR 只记录难反转、令人意外、有真实 trade-off 的决定；
- 没有这些文件时静默继续，不强制创建。

CONTEXT 迁入模板：

```markdown
# Context Name

One or two sentences describing this context.

## Language

**Canonical Term**:
One-sentence definition.
_Avoid_: AmbiguousAlias, OldName

## Relationships

- A **Term A** owns one or more **Term B**
- A **Term B** belongs to exactly one **Term A**

## Example dialogue

> **Dev:** "Question using the canonical terms?"
> **Domain expert:** "Answer that clarifies the relationship."

## Flagged ambiguities

- "account" was used for both **Customer** and **User**; use **Customer** for billing owner and **User** for auth identity.
```

ADR 迁入模板：

```markdown
# Short title of decision

One to three sentences: context, decision, and why.
```

ADR 判断标准：

```text
Create only when all are true:
- hard to reverse
- surprising without context
- result of a real trade-off
```

适合加入 `core-rules.md` 的短句：

```text
Use project vocabulary when available; do not invent synonyms for established concepts.
```

### 7. `review-mode.md`

用途：

用户要求 review 一个分支、PR、diff、WIP，尤其需要同时判断“是否符合项目标准”和“是否符合需求”。

核心规则：

- review 分两条轴：Standards 和 Spec；
- Standards 看是否违反项目文档化规则；
- Spec 看是否实现了原始需求、有无漏项或 scope creep；
- 不把两条轴混成一个模糊评分；
- findings 先行，summary 次要；
- 有文件和行号时必须引用。

可迁入流程：

```text
1. Pin fixed point
   - branch, commit, tag, or merge-base
   - default ask user when unclear

2. Gather spec
   - issue, PRD, docs, branch notes, or user-provided description

3. Gather standards
   - AGENTS.md / CLAUDE.md
   - CONTRIBUTING.md
   - CONTEXT.md / ADRs
   - lint/type/test configs as machine-enforced context

4. Review Standards
   - report documented-standard violations only
   - distinguish hard violations from judgment calls

5. Review Spec
   - missing requirements
   - incorrect implementation
   - behavior not asked for
```

### 8. `task-state-mode.md`

用途：

不迁入完整 issue triage，但把 triage 的状态机思想用于复杂 coding task。

可迁入状态：

```text
unknown:
Need to inspect code or clarify goal.

needs-info:
Blocked on a specific answer or artifact from user.

reproducing:
Building or running feedback loop.

ready-to-fix:
Symptom and expected behavior are clear.

fixing:
Implementing smallest change.

verified:
Relevant checks passed.

blocked:
Cannot proceed without external access, missing dependency, or unsafe assumption.
```

使用规则：

- `needs-info` 必须带具体问题，不写“请提供更多信息”；
- `blocked` 必须说明已尝试什么和缺什么；
- `verified` 必须说明用什么命令或观察验证；
- 状态只用于复杂任务，不用于简单一行修改。

### 9. 未来可添加的 scripts

不要现在就加脚本。只有当重复维护变得脆弱时再加。

候选脚本：

```text
scripts/check-references.sh
```

检查：

- `SKILL.md` 中引用的 `references/*.md` 是否存在；
- reference 文件是否有明显空文件；
- `agents/openai.yaml` 是否还存在；
- README 中的安装路径是否与实际目录一致。

```text
scripts/check-skill-size.sh
```

检查：

- `SKILL.md` 是否过长；
- description 是否超过推荐长度；
- reference 是否超过约定长度，需要拆分。

```text
scripts/hitl-loop-template.sh
```

用于无法自动复现的人工参与反馈环：

- 展示用户操作步骤；
- 捕获用户观察结果；
- 以 key=value 输出供 agent 读取。

### 建议迁移顺序

按收益和风险排序：

1. `diagnosis-mode.md`
2. `tdd-mode.md`
3. `brief-mode.md`
4. `architecture-mode.md`
5. `prototype-mode.md`
6. `context-adr-mode.md`
7. `review-mode.md`
8. `task-state-mode.md`
9. scripts

优先迁入前三个，因为它们最直接增强 `active-coding-rules` 当前的“验证、最小修改、清晰边界”能力。

### 再下一阶段建议

如果某些模式被高频使用，再考虑拆成独立 skills：

- `active-diagnose`
- `active-tdd`
- `active-architecture-review`
- `active-prototype`
- `active-agent-brief`

拆分前应确认：

- 该模式有稳定触发场景；
- 主 `active-coding-rules` 已经承载不了；
- 独立 metadata 能显著提高触发准确性；
- 不会让用户安装和维护成本过高。

## 建议加入 core rules 的短规则

后续可以把以下规则择优加入 `references/core-rules.md`：

```text
For hard bugs, build the tightest feedback loop before explaining the cause.
```

```text
One behavior, one failing test, one minimal implementation slice.
```

```text
Test through the smallest meaningful public interface.
```

```text
Add abstraction only when it increases locality or leverage.
```

```text
When unfamiliar with a code area, zoom out and map the relevant modules and callers first.
```

```text
Prototype code answers a question; production code owns a behavior.
```

```text
For substantial work, write the task as current behavior, desired behavior, acceptance criteria, and out of scope.
```

```text
Use project vocabulary when available; do not invent synonyms for established concepts.
```

## 本次变更文件

新增：

```text
active-coding-rules/references/matt-pocock-skills-lessons.md
MATT_SKILLS_INTEGRATION_REPORT.md
```

修改：

```text
active-coding-rules/SKILL.md
```

未修改：

```text
skills/
```

`skills/` 是本地下载的 Matt Skills 调研对象。本报告已经把后续需要逐步迁入的内容提取到“待逐步移入的内容提取”小节，因此后续可以从仓库中移除 `skills/`，不会影响 `active-coding-rules` 的演进依据。

## 验证

已运行 Codex skill validator：

```bash
python "$HOME/.codex/skills/.system/skill-creator/scripts/quick_validate.py" active-coding-rules
```

验证结果：

```text
Skill is valid!
```

## 最终评价

Matt Skills 对本仓库最大的启发是：好的 Agent Skill 不只是提醒 agent "要谨慎"，而是为不同工程场景提供正确的操作形状。

`active-coding-rules` 应继续作为默认安全驾驶模式存在；Matt 的经验应作为复杂场景的可加载 task modes 渐进融入。这样既能保留当前 Skill 的轻量优势，也能让它在 debugging、TDD、架构、原型和任务交接等复杂任务上更像一名稳定的高级工程师。
