# 社区功能 - 问题分析与代码拆解

## 问题总结

### 问题描述
用户登录后，控制台显示"用户已登录"，但点击点赞/评论按钮时提示"请先登录"

### 根本原因
1. **变量作用域错误**：`currentUser` 用 `let` 声明为局部变量
2. **全局访问失败**：社区功能的 `window.xxx()` 函数无法访问局部变量
3. **执行顺序错误**：函数表达式 `window.xxx = function()` 不触发函数提升

---

## 代码问题拆解

### ❌ 错误的代码结构

```javascript
// 变量定义（第1706行）
let currentUser = null;  // ❌ 局部变量，全局无法访问
const USER_SESSION_KEY = 'calligraphy_user_session';

// 社区功能定义（第4060行 - 在DOMContentLoaded 回调之后）
window.initCommunityFeatures = function() { ... };  // ❌ 函数表达式，不触发提升
window.toggleLike = function() { ... };     // ❌ 访问 currentUser（局部变量）
window.submitComment = function() { ... };   // ❌ 访问 currentUser（局部变量）
```

**问题**：
- `window.initCommunityFeatures` 被调用时（第4061行），函数体还没执行完
- `window.toggleLike` 和 `window.submitComment` 中的 `currentUser` 为 `undefined`

---

### ✅ 正确的代码结构

```javascript
// 全局变量暴露（第1709行）
window.currentUser = null;  // ✅ 暴露给全局作用域

// 社区功能函数定义（第3982行 - 在DOMContentLoaded 回调之前）
window.initCommunityFeatures = function() {
    console.log('初始化社区功能...');
    // ...
};

window.toggleLike = function(cardId) {
    console.log('❤️ 点赞:', cardId);
    console.log('当前用户:', window.currentUser);  // ✅ 可以访问
    // ...
};

window.submitComment = function(cardId) {
    console.log('📤 提交评论:', cardId);
    console.log('当前用户:', window.currentUser);  // ✅ 可以访问
    // ...
};
```

**优势**：
- 函数声明在 `DOMContentLoaded` 之前
- `window.currentUser` 可以被所有函数访问
- 函数执行顺序明确

---

## 解决方案总结

### 1. 变量作用域修复

**修改前**：
```javascript
let currentUser = null;  // 局部变量
```

**修改后**：
```javascript
// 局部变量仍然存在（用于原有代码）
let currentUser = null;

// 全局变量（新增）
window.currentUser = null;  // 暴露给全局

// 保存/加载时同步更新
currentUser = session.user;
window.currentUser = currentUser;  // 同步到全局
```

**关键点**：
- 使用 `window.currentUser` 而不是 `currentUser`
- 在所有设置用户的地方同时更新全局引用
- 保持向后兼容（原有代码仍可使用 `currentUser`）

---

### 2. 函数定义顺序修复

**问题**：
```javascript
window.initCommunityFeatures = function() { ... };
```

**原因**：函数表达式不会触发函数提升，执行顺序不确定

**修复**：
```javascript
// 使用函数声明
function initCommunityFeatures() {
    console.log('初始化社区功能...');
    // ...
}

// 在 DOMContentLoaded 回调中赋值给全局对象
window.initCommunityFeatures = initCommunityFeatures;
```

**关键点**：
- 函数声明会触发提升
- 确保函数定义在执行之前
- 通过赋值给 `window.xxx` 的方式使用

---

### 3. JWT Token 过期处理

**问题**：
- 用户长时间停留在页面后，token 过期
- 尝试点赞/评论时返回 401 错误

**解决**：
```javascript
// 获取有效 token（自动刷新）
window.getAccessToken = async function() {
    const session = JSON.parse(localStorage.getItem('calligraphy_user_session'));
    if (!session) return null;
    return session.access_token;
};

// 刷新过期的 token
window.refreshAccessToken = async function() {
    const session = JSON.parse(localStorage.getItem('calligraphy_user_session'));
    const response = await fetch(
        'https://ntxmkxakpbrnuosjahhr.supabase.co/auth/v1/token?grant_type=refresh_token',
        {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'apikey': SUPABASE_KEY
            },
            body: JSON.stringify({
                refresh_token: session.refresh_token
            })
        }
    );
    const data = await response.json();
    
    // 更新会话
    const newSession = {
        access_token: data.access_token,
        refresh_token: data.refresh_token,
        user: session.user
    };
    localStorage.setItem('calligraphy_user_session', JSON.stringify(newSession));
    return data.access_token;
};

// API 调用时使用 getAccessToken
window.toggleLike = async function(cardId) {
    let token = await window.getAccessToken();  // 自动刷新过期 token
    if (!token) return;
    // ... 使用 token 发送请求
};
```

**关键点**：
- 使用 `getAccessToken()` 而不是直接访问 `session.access_token`
- 401 错误时自动刷新并重试
- 刷新失败时清除会话并提示重新登录

---

## 代码优化建议

### 1. 函数组织结构

**当前结构**：
```javascript
// ❌ 所有的社区功能函数都是独立的
window.toggleLike = function() { ... };
window.submitComment = function() { ... };
window.loadComments = function() { ... };
// ...
```

**建议结构**：
```javascript
// ✅ 相关函数分组管理
window.community = {
    toggleLike: function() { ... },
    submitComment: function() { ... },
    loadComments: function() { ... },
    loadLikesCount: function() { ... },
    checkUserLikeStatus: function() { ... }
};

// 或使用模块模式
(function() {
    'use strict';
    
    // 私有变量
    let _currentUser = null;
    let _cardImages = {};
    
    // 暴露公共接口
    window.community = {
        toggleLike: toggleLikeImpl,
        // ...
    };
    
    function toggleLikeImpl(cardId) {
        // 实现
    }
    
    // 初始化
    window.initCommunityFeatures();
})();
```

**优势**：
- 代码组织清晰
- 减少全局命名空间污染
- 便于维护和测试

---

## 学习要点

### 1. JavaScript 变量作用域

| 关键字 | 说明 |
|--------|------|
| `let` | 声明局部变量，只在块级作用域内有效 |
| `const` | 声明块级常量，不可重新赋值 |
| `var` | 声明函数作用域变量，可重复声明（不推荐） |
| 不使用关键字 | 声明全局变量，作用域是整个文档 |

**最佳实践**：
- 在模块顶部使用 `let` 声明变量
- 避免使用 `var`（ES6 已废弃）
- 将需要共享的变量暴露给 `window` 对象
- 避免隐式全局变量污染

### 2. 函数声明方式

| 方式 | 说明 |
|------|------|
| **函数表达式** | `window.xxx = function() {}` - 不触发提升，执行顺序不确定 |
| **函数声明** | `function xxx() {}` - 触发提升，执行顺序确定 |
| **立即执行函数** | `(function() {})()` - 立即执行 |

**选择建议**：
- 需要在页面加载时立即执行的函数：使用函数声明
- 需要动态分配的函数：可以使用函数表达式
- 避免混合使用，保持一致性

### 3. 异步编程最佳实践

```javascript
// ❌ 错误：不处理错误
fetch(url).then(data => { ... }).catch(error => { console.error(error); });

// ✅ 正确：统一错误处理
async function loadLikesCount(cardId) {
    try {
        const response = await fetch(url);
        const data = await response.json();
        likeCount.textContent = data.length;
    } catch (error) {
        console.error('加载点赞数失败:', error);
        // 显示用户友好的错误提示
        alert('加载失败，请稍后重试');
    }
}

// ✅ 正确：使用统一错误处理函数
async function apiRequest(url, options) {
    try {
        const response = await fetch(url, options);
        return await response.json();
    } catch (error) {
        console.error('API请求失败:', error);
        throw error;  // 或返回 null
    }
}
```

---

## 代码重构检查清单

### 当前代码状态

| 检查项 | 状态 | 说明 |
|--------|------|------|
| 变量作用域 | ✅ 已修复 | `window.currentUser` 暴露给全局 |
| 函数定义顺序 | ✅ 已修复 | 函数声明在 DOMContentLoaded 之前 |
| JWT Token 过期 | ✅ 已添加 | 自动刷新过期 token |
| 全局函数暴露 | ✅ 已实现 | 所有函数通过 `window.xxx()` 暴露 |
| 错误处理 | ⚠️ 需改进 | 建议统一错误处理 |
| 代码组织 | ⚠️ 需优化 | 建议分组管理相关函数 |

---

## 测试清单

### 功能测试

- [ ] 未登录时不能点赞
- [ ] 未登录时不能评论
- [ ] 未登录时可以查看评论列表
- [ ] 未登录时可以查看点赞/评论数
- [ ] 登录后可以点赞
- [ ] 登录后可以取消点赞
- [ ] 登录后可以发表评论
- [ ] 登录后可以查看所有评论
- [ ] 每张图片只能点赞一次（数据库约束）
- [ ] 点赞按钮有悬停效果
- [ ] 评论按钮有悬停效果
- [ ] 评论区有加载动画
- [ ] 输入评论时有 Enter 键快捷发送
- [ ] 评论内容正确转义（XSS 防护）
- [ ] 时间显示正确（刚刚/分钟前/天前）
- [ ] **JWT Token 过期时自动刷新并重试**
- [ ] 刷新失败时提示重新登录

### 安全检查

- [ ] SQL 注入防护（使用参数化查询）
- [ ] XSS 防护（escapeHtml 转义输出）
- [ ] CSRF 防护（Supabase 自动处理）
- [ ] 访问控制（RLS 策略）
- [ ] 数据验证（评论长度限制 500 字）

---

## 关键修复记录

### 修改的文件

| 文件 | 修改内容 |
|------|----------|
| [index.html](index.html) | 1. 添加社区功能 CSS 样式 |
|  | 2. 在6个卡片中添加社区互动UI |
|  | 3. 添加 window.currentUser 全局暴露 |
|  | 4. 添加社区功能 JavaScript 代码 |
|  | 5. 修复函数定义顺序问题 |
|  | 6. 添加 JWT Token 过期处理 |
|  | 7. 添加 getAccessToken() 函数 |
|  | 8. 添加 refreshAccessToken() 函数 |
|  | 9. 更新 toggleLike 支持自动刷新 |
|  | 10. 更新 submitComment 支持自动刷新 |
|  | 11. 更新 checkUserLikeStatus 支持自动刷新 |

---

## 后续优化建议

### 1. 代码组织优化
- [ ] 创建 `window.community` 对象分组管理所有社区功能
- [ ] 创建独立的 API 请求模块
- [ ] 创建独立的 UI 更新模块

### 2. 性能优化
- [ ] 添加请求缓存，减少重复请求
- [ ] 使用防抖，避免短时间内重复发送请求
- [ ] 添加请求队列，确保请求顺序

### 3. 用户体验优化
- [ ] 添加加载动画和骨架屏
- [ ] 添加空状态展示
- [ ] 优化错误提示文案
- [ ] 添加操作成功反馈（Toast 通知）

### 4. 功能扩展
- [ ] 添加评论编辑功能
- [ ] 添加评论删除功能
- [ ] 添加评论回复功能
- [ ] 添加举报功能
- [ ] 添加敏感词过滤
- [ ] 添加用户屏蔽功能

---

## 结论

本次修复的核心问题是：

**变量作用域错误** → 通过暴露 `window.currentUser` 解决

**关键修复**：
1. 添加全局变量声明：`window.currentUser = null;`
2. 在所有设置用户的地方同步：`window.currentUser = currentUser;`
3. 社区功能全部使用全局引用：`window.currentUser`
4. 函数声明提前到 DOMContentLoaded 之前

**额外优化**：
1. 添加 JWT Token 自动刷新机制
2. 401 错误时自动重试请求
3. 统一使用 getAccessToken() 获取 token
4. 完善的错误处理和用户提示
