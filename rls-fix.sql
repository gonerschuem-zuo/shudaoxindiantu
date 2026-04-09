-- ========================================
-- 书道心电图 - 修复 RLS 策略支持演示数据
-- 版本: v1.03.1
-- 问题: 用户数据路径与演示数据冲突
-- ========================================

-- ========================================
-- Storage 策略修复
-- ========================================

-- 删除所有限制性策略
DROP POLICY IF EXISTS "Authenticated Read" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Upload" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Insert" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Update" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated Delete" ON storage.objects;

-- 创建新的宽松策略

-- 1. 所有登录用户和匿名用户都可以读取所有文件
CREATE POLICY "Public Read All Files"
ON storage.objects FOR SELECT
TO authenticated, anon
USING ( bucket_id = 'calligraphy-images' );

-- 2. 所有登录用户可以上传文件
CREATE POLICY "Authenticated Upload Files"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK ( bucket_id = 'calligraphy-images' );

-- 3. 用户只能删除自己上传的文件或演示数据
CREATE POLICY "Authenticated Delete Own Files"
ON storage.objects FOR DELETE
TO authenticated
USING (
    bucket_id = 'calligraphy-images'
    AND (
        (auth.uid()::text = SPLIT_PART(name, '/', 1))
        OR SPLIT_PART(name, '/', 1) ~ '^[0-9]+$'
    )
);

-- ========================================
-- 验证策略
-- ========================================

SELECT policyname, cmd, roles
FROM pg_policies
WHERE tablename = 'objects' AND schemaname = 'storage';
