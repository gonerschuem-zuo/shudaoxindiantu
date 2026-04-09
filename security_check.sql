-- ========================================
-- 书道心电图 - 社区功能权限配置与检查
-- 版本: v1.04.1
-- 用途: 配置和验证所有权限策略
-- ========================================

-- ========================================
-- 一、当前权限配置总结
-- ========================================

/*
📋 权限配置总结：

【点赞表 (calligraphy_likes)】
✅ 查看权限：所有人（包括未登录用户）
✅ 添加权限：仅登录用户，且只能以自己的身份点赞
✅ 删除权限：只能删除自己的点赞

【评论表 (calligraphy_comments)】
✅ 查看权限：所有人（包括未登录用户）
✅ 添加权限：仅登录用户，且只能以自己的身份发表
✅ 修改权限：只能修改自己的评论
✅ 删除权限：只能删除自己的评论
*/

-- ========================================
-- 二、安全配置检查清单
-- ========================================

/*
🔒 安全配置检查清单：

【基础权限】✅ 已配置
□ RLS (Row Level Security) 已启用
□ 匿名用户可查看（readonly）
□ 登录用户可操作自己的数据
□ 用户不能伪造他人身份

【数据完整性】⚠️ 部分需要考虑
□ 防止 XSS 攻击（前端已转义，数据库层面未做）
□ 防止 SQL 注入（使用参数化查询，Supabase自动处理）
□ 评论内容长度限制（已设置500字限制）
□ 防止垃圾评论（频率限制未实现）

【高级功能】❌ 未实现
□ 管理员权限（删除任何评论/点赞）
□ 评论审核机制
□ 用户屏蔽/拉黑功能
□ 举报功能
□ 敏感词过滤

【审计功能】❌ 未实现
□ 操作日志记录
□ 异常行为检测
*/

-- ========================================
-- 三、完整权限配置（重新应用）
-- ========================================

-- 3.1 点赞表权限

DROP POLICY IF EXISTS "Anyone can view likes" ON public.calligraphy_likes;
DROP POLICY IF EXISTS "Authenticated users can insert likes" ON public.calligraphy_likes;
DROP POLICY IF EXISTS "Users can delete own likes" ON public.calligraphy_likes;

CREATE POLICY "Anyone can view likes"
ON public.calligraphy_likes FOR SELECT
TO authenticated, anon
USING (true);

CREATE POLICY "Authenticated users can insert likes"
ON public.calligraphy_likes FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own likes"
ON public.calligraphy_likes FOR DELETE
TO authenticated
USING (auth.uid() = user_id);

-- 3.2 评论表权限

DROP POLICY IF EXISTS "Anyone can view comments" ON public.calligraphy_comments;
DROP POLICY IF EXISTS "Authenticated users can insert comments" ON public.calligraphy_comments;
DROP POLICY IF EXISTS "Users can update own comments" ON public.calligraphy_comments;
DROP POLICY IF EXISTS "Users can delete own comments" ON public.calligraphy_comments;

CREATE POLICY "Anyone can view comments"
ON public.calligraphy_comments FOR SELECT
TO authenticated, anon
USING (true);

CREATE POLICY "Authenticated users can insert comments"
ON public.calligraphy_comments FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own comments"
ON public.calligraphy_comments FOR UPDATE
TO authenticated
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own comments"
ON public.calligraphy_comments FOR DELETE
TO authenticated
USING (auth.uid() = user_id);

-- ========================================
-- 四、可选：管理员权限配置
-- ========================================

/*
⚠️ 注意：以下配置需要先创建 is_admin 函数或添加用户角色字段

-- 方法1：基于 user_metadata 判断管理员
CREATE POLICY "Admins can delete any comment"
ON public.calligraphy_comments FOR DELETE
TO authenticated
USING (
    auth.uid() IN (
        SELECT id FROM auth.users
        WHERE raw_user_meta_data->>'is_admin' = 'true'
    )
);

-- 方法2：基于独立的 admin_users 表
CREATE TABLE admin_users (
    user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE POLICY "Admins can delete any comment"
ON public.calligraphy_comments FOR DELETE
TO authenticated
USING (EXISTS (SELECT 1 FROM admin_users WHERE user_id = auth.uid()));
*/

-- ========================================
-- 五、验证当前权限配置
-- ========================================

-- 5.1 检查 RLS 是否启用
SELECT
    schemaname,
    tablename,
    rowsecurity AS rls_enabled,
    CASE WHEN rowsecurity THEN '✅ 已启用' ELSE '❌ 未启用' END AS status
FROM pg_tables
WHERE tablename IN ('calligraphy_likes', 'calligraphy_comments')
AND schemaname = 'public';

-- 5.2 检查所有策略
SELECT
    tablename AS "表名",
    policyname AS "策略名称",
    CASE cmd
        WHEN 'r' THEN '读取 (SELECT)'
        WHEN 'i' THEN '插入 (INSERT)'
        WHEN 'u' THEN '更新 (UPDATE)'
        WHEN 'd' THEN '删除 (DELETE)'
        WHEN '*' THEN '全部 (ALL)'
    END AS "操作类型",
    roles AS "适用角色",
    CASE
        WHEN cmd = 'r' AND roles = '{authenticated,anon}' THEN '✅ 所有人可读'
        WHEN cmd = 'r' AND roles = '{authenticated}' THEN '⚠️ 仅登录用户可读'
        WHEN cmd IN ('i','d','u') AND roles = '{authenticated}' THEN '✅ 仅登录用户可操作'
        ELSE '⚠️ 需要检查'
    END AS "状态"
FROM pg_policies
WHERE tablename IN ('calligraphy_likes', 'calligraphy_comments')
AND schemaname = 'public'
ORDER BY tablename, cmd;

-- 5.3 测试权限（需要用实际用户ID替换）

-- 测试1：匿名用户能否读取点赞（应该返回true）
-- SELECT EXISTS (
--     SELECT 1 FROM public.calligraphy_likes
--     LIMIT 1
-- ) AS "匿名用户可读点赞";

-- 测试2：匿名用户能否读取评论（应该返回true）
-- SELECT EXISTS (
--     SELECT 1 FROM public.calligraphy_comments
--     LIMIT 1
-- ) AS "匿名用户可读评论";

-- 测试3：当前登录用户能否读取所有数据
-- SELECT COUNT(*) AS "当前用户可见的评论数"
-- FROM public.calligraphy_comments;

-- ========================================
-- 六、安全建议
-- ========================================

/*
📌 建议实现的安全功能：

【高优先级】
1. ✅ 前端XSS防护：已使用 escapeHtml() 转义输出
2. ⚠️ 评论频率限制：防止刷屏（建议：每分钟最多3条评论）
3. ⚠️ 敏感词过滤：过滤辱骂、广告等内容

【中优先级】
4. 举报功能：用户可以举报不当评论
5. 评论审核：新评论需要管理员审核后显示
6. 用户屏蔽：用户可以屏蔽特定用户的评论

【低优先级】
7. 管理员后台：删除不当评论、封禁用户
8. 操作日志：记录所有评论/点赞操作
9. 异常检测：检测刷赞、恶意评论等行为

【实现示例 - 频率限制】
-- 添加 last_comment_at 字段到用户表
ALTER TABLE auth.users ADD COLUMN last_comment_at TIMESTAMPTZ;

-- 创建检查函数
CREATE OR REPLACE FUNCTION check_comment_rate_limit(user_uuid UUID)
RETURNS boolean AS $$
DECLARE
    last_comment TIMESTAMPTZ;
    minutes_since_last_comment NUMERIC;
BEGIN
    SELECT created_at INTO last_comment
    FROM public.calligraphy_comments
    WHERE user_id = user_uuid
    ORDER BY created_at DESC
    LIMIT 1;

    IF last_comment IS NULL THEN
        RETURN true; -- 首次评论，允许
    END IF;

    minutes_since_last_comment := EXTRACT(EPOCH FROM (NOW() - last_comment)) / 60;

    RETURN minutes_since_last_comment >= 1; -- 至少间隔1分钟
END;
$$ LANGUAGE plpgsql;
*/

-- ========================================
-- 七、快速修复脚本
-- ========================================

-- 如果发现问题，运行以下命令快速修复

-- 7.1 重新启用RLS
ALTER TABLE public.calligraphy_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.calligraphy_comments ENABLE ROW LEVEL SECURITY;

-- 7.2 重置所有策略（然后重新运行上面的权限配置）
-- DROP POLICY IF EXISTS "Anyone can view likes" ON public.calligraphy_likes;
-- （删除所有策略后重新创建）

-- 7.3 修复表结构
-- ALTER TABLE public.calligraphy_comments ALTER COLUMN user_name SET NOT NULL;
-- ALTER TABLE public.calligraphy_comments ALTER COLUMN user_email SET NOT NULL;

-- ========================================
-- 八、完成！
-- ========================================

SELECT '✅ 权限配置检查完成！' AS status;
SELECT '📋 请查看上方的检查结果' AS next_step;
SELECT '🔒 如果需要实现高级安全功能，请参考"六、安全建议"部分' AS security_tips;
