# 书道心电图 - 产品需求文档 (PRD)

## 项目概述

**项目名称**：书道心电图 - 书法卡片展示

**项目定位**：一个展示中国历代书法家的网页应用，采用现代化设计风格，结合传统书法美学，提供优雅的浏览体验。

**技术栈**：HTML + CSS + JavaScript + Supabase（云存储）

---

## 功能需求

### 1. 卡片展示功能

#### 1.1 卡片内容

- 展示6位中国著名书法家的信息卡片
- 每张卡片包含：
  - 书法家头像/作品图片
  - 书法家姓名
  - 生卒年份及朝代
  - 风格传承介绍
  - 装饰性印章

#### 1.2 卡片设计

- 采用水墨风格渐变背景
- 卡片悬停时有提升和阴影动画效果
- 响应式布局，自适应不同屏幕尺寸
- 装饰元素：水墨装饰、印章效果

### 2. 图片上传功能

#### 2.1 多图上传

- 一次可选择多张图片上传
- 支持JPG、PNG、GIF等常见图片格式
- 单个卡片最多支持10张图片
- 全局最多存储10000张图片

#### 2.2 图片处理

- 自动压缩图片（目标宽度1200px，质量0.85）
- 显示压缩进度和压缩率信息

#### 2.3 存储管理 ✨ 云存储 (v1.02)

- **云端存储**：上传到 Supabase Storage
- **多用户共享**：所有用户可以看到所有人上传的图片
- **本地缓存**：自动缓存到 localStorage
- **自动降级**：云端失败时使用本地存储
- 页面刷新后图片依然保留
- 显示存储图片数量和存储状态
- 提供清理缓存功能

### 3. 多图轮播功能

#### 3.1 轮播展示

- 支持在一个卡片内展示多张图片
- 当卡片有多张图片时自动启用轮播模式
- 单张图片时隐藏轮播控件

#### 3.2 自动播放

- 每3秒自动切换到下一张图片
- 鼠标悬停时暂停自动播放
- 鼠标移开后恢复自动播放

#### 3.3 手动控制

- **左右切换按钮**：点击可手动切换到上一张/下一张图片
- **指示器点**：底部显示小圆点，点击可跳转到指定图片
- **当前页码**：显示"1/5"格式的当前位置提示

#### 3.4 轮播动画

- 平滑的滑动过渡效果（0.5秒）
- 响应式指示器，高亮当前图片位置

#### 3.5 删除图片功能 ⚠️ 待修复

- **删除按钮**：每张图片右上角显示红色×按钮
- **悬停显示**：鼠标悬停时显示删除按钮
- **编辑模式**：编辑模式下删除按钮始终可见
- **确认对话框**：删除前弹出确认对话框，防止误删
- **智能更新**：删除后自动更新轮播图和页码显示

### 4. GIF导出功能

#### 4.1 导出按钮

- **半透明GIF按钮**：位于图片区域右下角，悬停时显示
- 按钮样式低调，不破坏卡片美观
- 仅在多图模式下显示，单图时自动隐藏

#### 4.2 GIF生成

- **自动等待图片加载**：确保所有图片完全加载后才开始生成
- **实时进度提示**：显示生成进度百分比
- **高质量输出**：400x300分辨率，每帧1秒持续时间

#### 4.3 自动下载

- 生成完成后自动触发下载
- 文件名格式：`书家-[名字].gif`（如：书家-王羲之.gif）
- 无需用户额外操作

### 5. 卡片交互功能

#### 5.1 卡片选择

- 点击卡片可选中/取消选中
- 选中的卡片有明显的视觉反馈（边框高亮）
- 提示文字显示选中状态
- 编辑模式下禁用卡片选择功能

#### 5.2 信息编辑功能

- **编辑模式切换**：点击"编辑信息"按钮进入/退出编辑模式
- **可编辑字段**：
  - 书法家图标（emoji）
  - 书法家姓名
  - 生卒年份及朝代
  - 风格传承标题
  - 风格传承描述
- **编辑状态特性**：
  - 所有卡片同时进入编辑状态
  - 卡片图片区域半透明显示
  - 绿色边框标识编辑状态
  - 顶部显示编辑提示横幅
  - 禁用照片上传功能
- **保存操作**：
  - 点击"保存"按钮保存单个卡片的修改
  - 修改自动保存到localStorage
  - 保存成功后显示提示反馈
- **取消操作**：
  - 点击"取消"按钮恢复该卡片的原始内容
  - 从localStorage或默认值恢复数据
- **数据持久化**：
  - 编辑后的信息永久保存
  - 页面刷新后自动加载保存的内容
  - 支持恢复到默认内容

---

## 配置参数

| 参数名称                     | 默认值                  | 说明                               |
| ---------------------------- | ----------------------- | ---------------------------------- |
| `STORAGE_KEY`                | 'calligraphy_images'    | 图片数据的localStorage键名         |
| `CARD_INFO_KEY`              | 'calligraphy_card_info' | 卡片信息的localStorage键名         |
| `MAX_IMAGES`                 | 10000                   | 全局最大图片数量                   |
| `MAX_IMAGES_PER_CARD`        | 10                      | 每个卡片最大图片数量               |
| `MAX_IMAGE_SIZE`             | 10MB                    | 单个图片最大文件大小               |
| `COMPRESS_TARGET_WIDTH`      | 1200px                  | 压缩目标宽度                       |
| `COMPRESS_QUALITY`           | 0.85                    | 压缩质量（0-1）                    |
| `CAROUSEL_AUTOPLAY_INTERVAL` | 3000ms                  | 轮播自动播放间隔                   |

### Supabase 配置 ✨ 新增 (v1.02)

| 参数名称           | 值                                              |
| ------------------ | ----------------------------------------------- |
| `SUPABASE_URL`     | https://ntxmkxakpbrnuosjahhr.supabase.co         |
| `SUPABASE_BUCKET`  | calligraphy-images                             |
| `SUPABASE_KEY`     | (anon key)                                      |

---

## 数据结构

### localStorage存储结构

#### 图片数据结构（v1.02 支持云端）

```javascript
{
  "cardId": {
    "images": [
      {
        "data": "https://xxx.supabase.co/storage/v1/object/public/...",  // 云端URL
        "path": "calligraphy-images/cardId/timestamp.ext",              // 云端路径
        "timestamp": 1234567890,
        "isCloud": true                                                   // 标记为云端图片
      },
      {
        "data": "base64...",                                             // 本地图片
        "timestamp": 1234567890,
        "isCloud": false                                                  // 标记为本地图片
      }
    ]
  }
}
```

#### 卡片信息数据结构

```javascript
{
  "cardId": {
    "icon": "🖌️",
    "name": "王羲之",
    "age": "303年-361年（东晋）",
    "styleTitle": "风格传承",
    "styleDesc": "书圣，承钟繇、卫铄之法，创\"王体\"行书..."
  }
}
```

### Supabase Storage 数据组织（v1.03） ⭐ 重要

#### 文件路径格式

```
calligraphy-images/
│
├── {cardId}/{fileName}           ← 演示数据（公共资产）
│   ├── 1/wangxizhi.jpg
│   ├── 1/lantingxu.jpg
│   ├── 2/yanzhenqing.jpg
│   └── ...
│
└── {userId}/{cardId}/{fileName}  ← 用户数据（个人资产）
    ├── user-abc-123/1/my_work.jpg
    ├── user-abc-123/2/practice.jpg
    └── user-xyz-789/1/calligraphy.jpg
```

#### 数据分类说明

| 数据类型 | 路径格式 | 所属权 | 可见性 | 可删除性 | 说明 |
|---------|---------|--------|--------|----------|------|
| **演示数据** | `{cardId}/{fileName}` | 公共 | 所有用户 | 所有用户 | 书法家的代表作品，作为默认展示 |
| **用户数据** | `{userId}/{cardId}/{fileName}` | 私有 | 仅上传者 | 仅上传者 | 用户个人上传的练习作品 |

#### 和谐共存机制

**读取权限**：
- ✅ 演示数据：所有用户（包括未登录）都能查看
- ✅ 用户数据：仅上传者能查看
- ✅ 同一卡片可以同时显示演示图片和用户图片

**写入权限**：
- ✅ 上传：所有登录用户都可以上传
- ✅ 删除：只能删除自己上传的图片（通过路径识别）

**RLS 策略**：
```sql
-- 允许所有用户读取所有文件
CREATE POLICY "Public Read All Files"
ON storage.objects FOR SELECT
TO authenticated, anon
USING (bucket_id = 'calligraphy-images');

-- 允许用户删除自己的文件或演示数据
CREATE POLICY "Authenticated Delete Own Files"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'calligraphy-images'
    AND (
        (auth.uid()::text = SPLIT_PART(name, '/', 1))  -- 自己的数据
        OR SPLIT_PART(name, '/', 1) ~ '^[0-9]+$'      -- 演示数据
    )
);
```

#### 代码实现

```javascript
// 同时加载演示数据和用户数据
async function loadUserImages() {
    // 1. 加载演示数据（前缀为空）
    const demoResponse = await fetch('list?prefix=');

    // 2. 加载用户专属数据（前缀为 userId）
    const userResponse = await fetch(`list?prefix=${currentUser.id}/`);

    // 3. 智能合并
    const allFiles = [...demoFiles, ...userFiles];
    allFiles.forEach(file => {
        // 识别路径格式
        const parts = file.name.split('/');
        if (parts.length === 2 && parts[0].match(/^\d+$/)) {
            // 演示数据：{cardId}/{fileName}
        } else if (parts[0] === currentUser.id) {
            // 用户数据：{userId}/{cardId}/{fileName}
        }
    });
}
```
    "age": "303年-361年（东晋）",
    "styleTitle": "风格传承",
    "styleDesc": "书圣，承钟繇、卫铄之法，创\"王体\"行书..."
  }
}
```

---

## 用户操作流程

### 上传图片流程（v1.02 云存储）

1. 点击想要更换图片的卡片
2. 点击"添加照片（支持多选）"按钮
3. 在文件选择对话框中选择一张或多张图片
4. 系统自动尝试上传到云端
5. 上传成功后显示："图片已保存到云端，其他用户也可以看到！"
6. 其他用户刷新页面后可以看到你上传的图片

### 轮播图使用流程

1. 上传多张图片到同一卡片后自动启用轮播
2. 图片每3秒自动切换
3. 可通过左右箭头手动切换
4. 可点击底部指示器跳转到指定图片
5. 查看右下角页码了解当前位置

### 删除图片流程 ⚠️ 待修复

1. 鼠标悬停在轮播图上，图片右上角显示删除按钮
2. 或进入编辑模式，删除按钮始终可见
3. 点击要删除图片的×按钮
4. 在确认对话框中点击"确认删除"
5. 系统删除图片并自动更新轮播图

---

## 版本历史

### v1.04.0 (2026-04-09) - 社区互动功能 ✨

#### 新增功能
- ✨ 新增点赞功能（用户可以为喜欢的作品点赞）
- ✨ 新增评论功能（用户可以发表评论分享想法）
- ✨ 新增点赞数和评论数实时统计
- ✨ 新增评论区展开/收起功能
- ✨ 新增评论列表展示（按时间倒序）
- ✨ 新增用户身份验证（登录后才能点赞和评论）
- ✨ 新增 JWT Token 自动刷新机制（解决长时间停留页面后的过期问题）
- ✨ 新增 XSS 防护（评论内容自动转义）
- ✨ 新增智能时间显示（刚刚/分钟前/天前）
- ✨ 新增 Enter 键快捷发送评论

#### 数据库设计
**新增表**：
- `calligraphy_likes` - 点赞表
  - 字段：id, user_id, card_id, image_path, created_at
  - 约束：UNIQUE(user_id, image_path) - 每个用户对同一图片只能点赞一次
- `calligraphy_comments` - 评论表
  - 字段：id, user_id, user_name, user_email, card_id, image_path, content, created_at, updated_at
  - 约束：content 长度 1-500 字

**RLS 策略**：
- 点赞表：所有人可查看，登录用户可点赞/取消点赞
- 评论表：所有人可查看，登录用户可发表/编辑/删除自己的评论

#### 权限设计
| 操作 | 未登录用户 | 登录用户 |
|------|-----------|---------|
| 查看点赞数 | ✅ | ✅ |
| 查看评论数 | ✅ | ✅ |
| 查看评论列表 | ✅ | ✅ |
| 点赞 | ❌ 提示登录 | ✅ |
| 取消点赞 | ❌ | ✅ |
| 发表评论 | ❌ 提示登录 | ✅ |
| 编辑评论 | ❌ | ✅ 仅自己的 |

#### 交互设计
**点赞按钮**：
- 默认状态：🤍 空心
- 已点赞状态：❤️ 红心 + 渐变背景
- 悬停效果：放大 + 边框变色
- 点击反馈：平滑过渡动画

**评论按钮**：
- 显示评论数量徽章
- 悬停效果：放大 + 边框变色
- 点击展开评论区

**评论区**：
- 默认隐藏，点击展开
- 评论列表最多显示 300px 高度，超出滚动
- 输入框支持多行（自动调整高度）
- Enter 键快捷发送（Shift+Enter 换行）
- 发送中状态：按钮禁用 + 显示"发送中..."

#### 用户体验优化
1. **自动 Token 刷新**：用户长时间停留页面后，token 过期时自动刷新，无需重新登录
2. **实时统计更新**：点赞/评论成功后立即更新计数
3. **友好错误提示**：所有操作失败都有明确的错误提示
4. **加载状态反馈**：评论区显示"加载评论中..."
5. **空状态提示**：暂无评论时显示鼓励性文案

#### 技术实现
**前端架构**：
- 使用全局函数暴露：`window.toggleLike()`, `window.submitComment()` 等
- 使用原生 fetch API 进行 HTTP 请求
- 使用 localStorage 持久化用户会话（access_token + refresh_token）

**后端集成**：
- Supabase Auth 用户认证
- Supabase RESTful API 数据操作
- Supabase RLS（Row Level Security）权限控制

**安全措施**：
1. **防 SQL 注入**：使用参数化查询
2. **防 XSS 攻击**：使用 `escapeHtml()` 转义输出
3. **防 CSRF 攻击**：Supabase 自动处理
4. **防重复点赞**：数据库 UNIQUE 约束
5. **权限控制**：RLS 策略 + `auth.uid()` 验证

#### 问题与解决方案

| # | 问题 | 症状 | 根本原因 | 解决方案 |
|---|------|------|----------|----------|
| 1 | 登录后无法点赞 | 提示"请先登录" | `currentUser` 是局部变量，社区功能无法访问 | 添加 `window.currentUser` 全局暴露 |
| 2 | 所有按钮失效 | 点击无反应 | 在破损代码上迭代修改 | 回退到稳定版本重新实现 |
| 3 | DOM 元素为 null | `getElementById` 返回 null | 代码在 DOM 加载前执行 | 移到 DOMContentLoaded 内部 |
| 4 | 事件绑定失效 | 替换 HTML 后按钮不工作 | 事件监听器未重新绑定 | 使用 HTML onclick 属性 |
| 5 | 函数未定义错误 | `window.initCommunityFeatures is not a function` | 函数表达式不触发提升，执行顺序错误 | 提前到 DOMContentLoaded 之前定义 |
| 6 | JWT Token 过期 | API 请求返回 401 | Access token 有效期1小时，过期后无法使用 | 添加 refresh_token 自动刷新机制 |

**关键修复**：
```javascript
// 1. 全局变量暴露（解决作用域问题）
window.currentUser = null;

// 2. 在所有设置用户的地方同步
currentUser = session.user;
window.currentUser = currentUser;  // 同步到全局

// 3. 社区功能使用全局引用
window.toggleLike = function(cardId) {
    console.log('当前用户:', window.currentUser);  // ✅ 可以访问
    // ...
};

// 4. JWT Token 自动刷新
window.getAccessToken = async function() {
    // 获取有效的 token，如果过期则自动刷新
};

// 5. API 调用时使用 getAccessToken
let token = await window.getAccessToken();
// 使用 token 发送请求
if (response.status === 401) {
    token = await window.refreshAccessToken();  // 自动刷新
    response = await makeRequest(token);  // 重试
}
```

#### 数据库迁移
- 新增 `calligraphy_likes` 表
- 新增 `calligraphy_comments` 表
- 添加 `user_name` 和 `user_email` 字段到评论表（冗余存储）
- 配置 RLS 策略
- 创建索引优化查询性能

#### 开发经验
- 🔧 **重要原则**：不要在破损代码基础上迭代修改，回退到稳定版本重新实现
- 🔧 **变量作用域**：使用 `let` 声明的变量只在块级作用域内有效，需要共享的变量暴露给 `window`
- 🔧 **函数提升**：函数声明会触发提升，函数表达式不会
- 🔧 **全局函数**：使用 `window.xxx = function()` 暴露函数给全局作用域
- 🔧 **错误处理**：所有异步操作都应该有 try-catch 和用户友好的错误提示
- 🔧 **Token 管理**：使用 refresh_token 实现无感刷新，提升用户体验

#### 已知问题
- ⚠️ 暂不支持评论编辑功能（数据库已支持，前端未实现）
- ⚠️ 暂不支持评论删除功能
- ⚠️ 暂不支持举报功能
- ⚠️ 暂不支持敏感词过滤

#### 后续规划
- [ ] 添加评论编辑功能
- [ ] 添加评论删除功能
- [ ] 添加评论回复功能
- [ ] 添加举报功能
- [ ] 添加敏感词过滤
- [ ] 添加用户屏蔽功能
- [ ] 优化移动端展示效果

---

### v1.03.0 (2026-04-09) - 用户认证系统 ✨

#### 新增功能
- ✨ 新增用户注册功能（邮箱+密码）
- ✨ 新增用户登录功能（Supabase Auth）
- ✨ 新增用户数据隔离（每个用户只能看到自己的图片）
- ✨ 新增登录状态持久化（localStorage）
- ✨ 新增用户专属图片目录（{userId}/{cardId}/{fileName}）
- 🎨 优化 UI：登录后显示用户名和退出按钮

#### 开发经验
- 🔧 回退到稳定版本（v1.02.1）后重新实现，避免累积问题
- 🔧 使用 HTML onclick 属性代替事件监听器，提高可靠性

#### 问题与解决方案（详细清单）

| # | 问题 | 症状 | 根本原因 | 解决方案 |
|---|------|------|----------|----------|
| 1 | 所有按钮失效 | 点击无反应 | 在破损代码上迭代修改 | 回退到工作版本重新实现 |
| 2 | DOM 元素为 null | `getElementById` 返回 null | 代码在 DOM 加载前执行 | 移到 DOMContentLoaded 内部 |
| 3 | 事件绑定失效 | 替换 HTML 后按钮不工作 | 事件监听器未重新绑定 | 使用 HTML onclick 属性 |
| 4 | 脚本执行中断 | 部分功能不工作 | 代码重复导致结构混乱 | 删除重复代码 |
| 5 | 演示数据不可见 | 登录后看不到默认图片 | 只查询 `{userId}/` 前缀 | 同时加载演示和用户数据 |
| 6 | RLS 策略阻止访问 | Storage 拒绝读取请求 | 策略限制过于严格 | 修改为宽松策略 |

**详细问题分析**：

**问题 1：在破损代码基础上迭代**
```
症状：添加新功能后原有功能失效，按钮点击无反应
原因：在已有问题的版本上继续修改，问题累积
解决：git reset --hard <working-commit> 回退到稳定版本
```

**问题 2：DOM 元素获取返回 null**
```javascript
// ❌ 错误：在 script 开始时获取
const uploadBtn = document.getElementById('uploadBtn');  // null

// ✅ 正确：在 DOMContentLoaded 内获取
window.addEventListener('DOMContentLoaded', () => {
    const uploadBtn = document.getElementById('uploadBtn');
});
```

**问题 3：事件绑定失效**
```javascript
// ❌ 错误：动态替换 HTML 后事件丢失
element.innerHTML = '<button id="btn">点击</button>';
// 之前绑定的事件丢失了

// ✅ 正确：使用 onclick 属性
element.innerHTML = '<button onclick="handleClick()">点击</button>';
```

**问题 4：代码重复和结构混乱**
```javascript
// ❌ 错误：同样的代码在两个地方
// 第 3667 行：DOMContentLoaded 之外
cards.forEach(...);  // cards 是 null

// 第 3922 行：DOMContentLoaded 之内
cards.forEach(...);  // 正确位置

// ✅ 正确：删除重复代码，只保留在正确位置
```

**问题 5：演示数据不可见**
```javascript
// ❌ 错误：只查询用户专属目录
const response = await fetch(`list?prefix=${currentUser.id}/`);

// ✅ 正确：同时查询演示数据和用户数据
const demoResponse = await fetch('list?prefix=');  // 演示数据
const userResponse = await fetch(`list?prefix=${currentUser.id}/`);  // 用户数据
```

**问题 6：RLS 策略阻止访问**
```sql
-- ❌ 错误：限制只能查看自己的数据
USING (auth.uid() = user_id)

-- ✅ 正确：允许查看演示数据（user_id IS NULL）
USING (user_id = auth.uid() OR user_id IS NULL)
```

---

### v1.02.1 (2026-04-08) - 删除功能修复版本

- 🔧 完全重写删除功能，使用CSS hover显示删除按钮
- 🔧 使用原生confirm对话框，简化用户操作流程
- 🔧 支持选择性删除：确定删除本地+云端，取消只删除本地
- 🔧 修复删除按钮事件绑定问题
- 🔧 使用data属性传递参数，避免闭包问题
- 🔧 简化代码结构，提高可维护性

### v1.02 (2026-04-06) - 云存储版本

- ✨ 新增 Supabase 云存储支持
- ✨ 新增多用户图片共享功能
- ✨ 新增云端图片自动同步
- ✨ 新增云端图片删除功能
- ✨ 自动降级：云端失败时使用本地存储
- 🔧 使用纯 REST API，避免 SDK 加载问题
- 🔧 修复 Supabase URL 生成逻辑
- 🔧 修复删除按钮位置（移到左上角）
- 🔧 修复删除按钮显示逻辑

### v1.3.1 (2026-04-04) - 删除图片功能

- ✨ 新增单张图片删除功能
- ✨ 新增删除确认对话框，防止误删
- ✨ 删除按钮悬停显示
- ✨ 编辑模式下删除按钮始终可见
- 🎨 优化删除按钮样式（红色×按钮）
- 🔧 删除后自动更新轮播图和页码

### v1.3.0 (2026-04-04) - GIF导出版本

- ✨ 新增GIF动图导出功能
- ✨ 新增半透明GIF导出按钮（悬停显示）
- ✨ 自动下载功能，文件名为"书家-[名字].gif"
- ✨ 智能等待图片完全加载后生成
- ✨ 实时生成进度提示
- 🎨 优化按钮样式，不破坏卡片美观
- 🔧 使用gifshot库进行GIF编码

### v1.2.0 (2026-04-04) - 信息编辑版本

- ✨ 新增信息编辑功能
- ✨ 支持编辑所有卡片文字信息
- ✨ 新增编辑模式切换按钮
- ✨ 新增保存/取消编辑操作
- ✨ 编辑信息持久化到localStorage
- 🎨 优化编辑状态UI视觉效果
- 🔧 编辑模式下禁用图片上传功能

### v1.1.0 (2026-04-04) - 多图轮播版本

- ✨ 新增多图上传功能
- ✨ 新增轮播图组件
- ✨ 新增自动播放功能（3秒间隔）
- ✨ 新增手动切换按钮
- ✨ 新增页码显示
- ✨ 新增指示器导航
- 🔧 优化localStorage存储结构

### v1.0.0 - 初始版本

- 基础卡片展示
- 单图上传功能
- localStorage存储
- 存储管理功能

---

## 浏览器兼容性

- Chrome/Edge: 完全支持
- Firefox: 完全支持
- Safari: 完全支持
- 需要支持ES6+语法

---

## 已完成功能 ✅

- ✅ 6位书法家卡片展示
- ✅ 多图上传（支持多选）
- ✅ 图片自动压缩
- ✅ 多图轮播（自动+手动）
- ✅ GIF导出功能（按上传顺序生成）
- ✅ 卡片信息编辑
- ✅ 图片删除功能（悬停显示×按钮）
- ✅ 删除确认对话框（选择删除本地或本地+云端）
- ✅ Supabase 云存储
- ✅ **用户注册/登录系统**
- ✅ **用户数据隔离（每个用户只能管理自己的图片）**
- ✅ **登录状态持久化**
- ✅ **社区互动功能：点赞（用户可为喜欢的作品点赞）**
- ✅ **社区互动功能：评论（用户可发表评论分享想法）**
- ✅ **JWT Token 自动刷新（解决长时间停留页面后的过期问题）**
- ✅ **实时统计点赞/评论数**
- ✅ **评论区展开/收起**
- ✅ **评论列表展示（按时间倒序）**
- ✅ **XSS 防护（评论内容自动转义）**

---

## 待修复问题 ⚠️

- ⚠️ 无（所有核心功能已完成）

---

## 开发经验总结 💡

### 问题：在破损代码基础上迭代导致更多问题

**症状**：
- 添加新功能后原有功能失效
- 按钮点击无反应
- 无法定位具体问题原因

**根本原因**：
1. 在已有问题的版本上继续修改
2. 问题累积，越来越复杂
3. 修改引入新问题，形成恶性循环

**解决方案**：
```bash
# 回退到最后工作的版本
git log --oneline -10  # 查看提交历史
git reset --hard <working-commit>  # 回退

# 在稳定基础上重新实现
git add -A
git commit -m "feat: 重新实现功能"
```

---

### 问题：DOM 元素获取返回 null

**症状**：
```javascript
const uploadBtn = document.getElementById('uploadBtn');
console.log(uploadBtn);  // null
uploadBtn.addEventListener(...);  // 报错
```

**根本原因**：
- 代码在 `<script>` 标签开始时立即执行
- 此时 DOM 还未加载完成
- 所有 `getElementById` 都返回 `null`

**解决方案**：
```javascript
// ❌ 错误：在 script 标签开始时执行
<script>
const uploadBtn = document.getElementById('uploadBtn');  // null
</script>

// ✅ 正确：在 DOMContentLoaded 内执行
<script>
window.addEventListener('DOMContentLoaded', function() {
    const uploadBtn = document.getElementById('uploadBtn');  // 正确获取
});
</script>

// ✅ 更好：在需要时才获取（函数内）
function handleClick() {
    const uploadBtn = document.getElementById('uploadBtn');
    if (uploadBtn) {
        uploadBtn.addEventListener(...);
    }
}
```

---

## 演示数据与用户数据共存机制 ⭐ v1.03

### 设计理念

在 v1.03 版本中，我们引入了用户认证系统，但同时保留了对演示数据的支持。这样新用户可以看到精美的书法作品，同时也可以上传自己的练习作品。

### 存储结构对比

#### v1.02 版本（无用户系统）
```
calligraphy-images/
├── 1/wangxizhi.jpg       ← 所有用户共享
├── 1/lantingxu.jpg       ← 所有用户共享
├── 2/yanzhenqing.jpg     ← 所有用户共享
└── ...
```

#### v1.03 版本（有用户系统）
```
calligraphy-images/
├── 1/wangxizhi.jpg              ← 演示数据（公共资产）
├── 1/lantingxu.jpg              ← 所有用户可见
├── 2/yanzhenqing.jpg            ← 所有用户可见
│
├── user-abc-123/1/my_work.jpg   ← 用户 A 的数据
├── user-abc-123/2/practice.jpg   ← 仅用户 A 可见
│
└── user-xyz-789/1/calligraphy.jpg ← 用户 B 的数据
    └── user-xyz-789/3/art.jpg      ← 仅用户 B 可见
```

### 数据访问规则详解

#### 未登录用户
| 数据类型 | 能否查看 | 能否删除 | 说明 |
|---------|---------|---------|------|
| 演示数据 | ✅ 能 | ✅ 能 | 默认展示的书法作品 |
| 用户数据 | ❌ 不能 | ❌ 不能 | 需要登录才能查看 |

#### 用户 A 登录后
| 数据类型 | 能否查看 | 能否删除 | 说明 |
|---------|---------|---------|------|
| 演示数据 | ✅ 能 | ✅ 能 | 公共资产，可删除 |
| 用户 A 的数据 | ✅ 能 | ✅ 能 | 自己上传的图片 |
| 用户 B 的数据 | ❌ 不能 | ❌ 不能 | 其他用户的私有数据 |

### RLS 策略配置

#### 问题场景
如果 RLS 策略配置不当，会出现以下问题：

1. **演示数据被隐藏**：
   - 症状：登录后看不到默认的书法作品
   - 原因：策略限制为 `auth.uid() = user_id`，但演示数据没有 user_id
   - 解决：允许 `user_id IS NULL` 的数据被查看

2. **Storage 拒绝访问**：
   - 症状：API 返回 401/403 错误
   - 原因：Storage 策略只允许访问特定前缀
   - 解决：创建宽松的读取策略

#### 正确的 RLS 策略配置

```sql
-- ❌ 错误：过于严格的策略
CREATE POLICY "Users can view their own images"
ON storage.objects FOR SELECT
USING (auth.uid() = SPLIT_PART(name, '/', 1));
-- 问题：演示数据路径为 "1/file.jpg"，不匹配用户 ID

-- ✅ 正确：宽松的读取策略
CREATE POLICY "Public Read All Files"
ON storage.objects FOR SELECT
TO authenticated, anon
USING (bucket_id = 'calligraphy-images');
-- 允许：所有用户读取所有文件

-- ✅ 正确：受控的删除策略
CREATE POLICY "Authenticated Delete Own Files"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'calligraphy-images'
    AND (
        (auth.uid()::text = SPLIT_PART(name, '/', 1))  -- 自己的文件
        OR SPLIT_PART(name, '/', 1) ~ '^[0-9]+$'      -- 演示文件
    )
);
```

### 代码实现要点

#### 路径格式识别
```javascript
// 识别两种路径格式
const parts = file.name.split('/');

if (parts.length === 2 && parts[0].match(/^\d+$/)) {
    // 演示数据："1/wangxizhi.jpg"
    cardId = parts[0];
    isDemo = true;
} else if (parts[0] === currentUser.id) {
    // 用户数据："user-abc-123/1/my_work.jpg"
    cardId = parts[1];
    isDemo = false;
}
```

#### 合并显示逻辑
```javascript
// 同一卡片可以显示多种数据源
const cardImages = [
    ...demoData[cardId],   // 演示图片
    ...userData[cardId]    // 用户图片
];
// 去重后显示
createCarousel(card, cardImages);
```

### 用户体验

1. **首次访问（未登录）**：
   - 看到：精美的书法作品（演示数据）
   - 鼓励：注册后可以上传自己的作品

2. **注册登录后**：
   - 看到：演示数据 + 自己上传的图片
   - 可以：上传、删除自己的图片

3. **图片展示**：
   - 卡片 1 = 演示图片（兰亭序） + 用户 A 的作品 + 用户 B 的作品
   - 每个人只能删除自己上传的部分
   - 演示图片保持不变（公共资产）

### 数据迁移建议

如果之前有旧版本的图片数据：

1. **保留旧数据**：不要删除演示数据
2. **添加新数据**：新上传的图片使用新路径格式
3. **逐步迁移**：如果需要，可以给旧数据添加标记

### 测试清单

- [ ] 未登录用户能看到演示数据
- [ ] 未登录用户不能看到用户数据
- [ ] 登录后能看到演示数据 + 自己的数据
- [ ] 登录后不能看到其他用户的数据
- [ ] 可以删除演示数据（公共资产）
- [ ] 只能删除自己上传的数据
- [ ] RLS 策略不会阻止正常访问

---

### 问题：事件绑定失效

**症状**：
```javascript
btn.onclick = handleClick;
// 动态替换 HTML 后事件失效
btn.innerHTML = '<button onclick="handleClick()">点击</button>';  // 不工作
```

**根本原因**：
- 替换 HTML 后，新元素需要重新绑定事件
- 使用 `addEventListener` 绑定的旧元素已被移除

**解决方案**：
```javascript
// ✅ 方案 1：使用 HTML onclick 属性（最简单）
element.innerHTML = '<button onclick="handleClick()">点击</button>';

// ✅ 方案 2：替换 HTML 后重新绑定
element.innerHTML = '<button id="myBtn">点击</button>';
document.getElementById('myBtn').onclick = handleClick;

// ✅ 方案 3：使用事件委托（最可靠）
document.addEventListener('click', function(e) {
    if (e.target.id === 'myBtn') {
        handleClick();
    }
});
```

---

### 调试技巧

**1. 检查元素是否存在**：
```javascript
const btn = document.getElementById('myBtn');
console.log('Button:', btn);  // 检查是否为 null
```

**2. 检查事件是否绑定**：
```javascript
console.log('Onclick:', btn.onclick);  // 应该看到函数
```

**3. 使用 try-catch 捕获错误**：
```javascript
try {
    btn.addEventListener('click', handler);
} catch (error) {
    console.error('绑定失败:', error);
}
```

**4. 分步骤测试**：
- 先测试基础功能（按钮点击）
- 再测试复杂功能（异步请求）
- 最后测试集成功能（完整流程）

---

## 未来规划

- [ ] 添加评论编辑功能
- [ ] 添加评论删除功能
- [ ] 添加评论回复功能
- [ ] 添加举报功能
- [ ] 添加敏感词过滤
- [ ] 添加用户屏蔽功能
- [ ] 添加批量编辑功能
- [ ] 支持恢复默认内容按钮
- [ ] 添加卡片信息验证
- [ ] 支持导出/导入卡片信息
- [ ] 添加图片拖拽排序功能
- [ ] 添加全屏查看模式
- [ ] 添加更多书法家卡片
- [ ] 支持自定义轮播间隔时间
- [ ] 添加编辑历史记录功能
- [ ] 支持自定义GIF分辨率和帧率
- [ ] 添加批量导出所有卡片为GIF功能
