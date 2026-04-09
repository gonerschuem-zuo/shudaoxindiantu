-- ========================================
-- 紧急修复：启用 RLS（行级安全）
-- ========================================

-- 问题：RLS 未启用，导致所有权限策略失效
-- 风险：任何用户都可以删除/修改任何数据

-- 启用 RLS
ALTER TABLE public.calligraphy_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.calligraphy_comments ENABLE ROW LEVEL SECURITY;

-- 验证修复结果
SELECT
    tablename AS "表名",
    CASE rowsecurity
        WHEN true THEN '✅ RLS 已启用'
        ELSE '❌ RLS 未启用（危险！）'
    END AS "RLS状态"
FROM pg_tables
WHERE tablename IN ('calligraphy_likes', 'calligraphy_comments')
AND schemaname = 'public';

-- 验证策略状态
SELECT
    tablename AS "表名",
    policyname AS "策略名称",
    CASE cmd
        WHEN 'r' THEN '读取'
        WHEN 'i' THEN '插入'
        WHEN 'u' THEN '更新'
        WHEN 'd' THEN '删除'
    END AS "操作",
    CASE
        WHEN cmd = 'r' AND roles = '{authenticated,anon}' THEN '✅ 所有人'
        WHEN cmd IN ('i','u','d') AND roles = '{authenticated}' THEN '✅ 仅登录用户'
        ELSE '⚠️ 需要检查'
    END AS "权限"
FROM pg_policies
WHERE tablename IN ('calligraphy_likes', 'calligraphy_comments')
AND schemaname = 'public'
ORDER BY tablename, cmd;

-- 最终状态
SELECT '✅ 修复完成！RLS 已启用，权限策略已生效' AS "状态";
